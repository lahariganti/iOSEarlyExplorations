//
//  RecordTuneVC.swift
//  WhatIsThatTune
//
//  Created by Lahari Ganti on 9/3/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import AVFoundation

class RecordTuneVC: UIViewController {
	var stackView: UIStackView! = {
		let stack = UIStackView()
		stack.spacing = 32
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.distribution = .fillEqually
		stack.alignment = .center
		stack.axis = .vertical
		return stack
	}()

	var recordButton: UIButton!
	var playButton: UIButton!

	var recordingSession: AVAudioSession!
	var tuneRecorder: AVAudioRecorder!

	var tunePlayer: AVAudioPlayer!

	func setupStackView() {
		stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}

	override func loadView() {
		view = UIView()
		view.backgroundColor = .lightGray
		view.addSubview(stackView)
		setupStackView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Record your tune"
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
		recordingSession = AVAudioSession.sharedInstance()

		do {
			try recordingSession.setCategory(.playAndRecord, mode: .default)
			try recordingSession.setActive(true)
			recordingSession.requestRecordPermission() { [unowned self] allowed in
				DispatchQueue.main.async {
					if allowed {
						self.loadRecordingUI()
					} else {
						self.loadFailUI()
					}
				}

			}
		} catch {
			loadFailUI()
		}
	}

	func loadRecordingUI() {
		recordButton = UIButton()
		recordButton.translatesAutoresizingMaskIntoConstraints = false
		recordButton.setTitle("Tap to Record", for: .normal)
		recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
		recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
		stackView.addArrangedSubview(recordButton)

		playButton = UIButton()
		playButton.translatesAutoresizingMaskIntoConstraints = false
		playButton.setTitle("Tap to Play", for: .normal)
		playButton.isHidden = true
		playButton.alpha = 0
		playButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
		playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
		stackView.addArrangedSubview(playButton)

		recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
		playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
		stackView.addArrangedSubview(recordButton)
	}

	func loadFailUI() {
		let failLabel = UILabel()
		failLabel.text = "Recording failed: please ensure the app has access to your microphone."
		failLabel.numberOfLines = 0
		stackView.addArrangedSubview(playButton)
	}

	class func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}

	class func getTuneURL() -> URL {
		return getDocumentsDirectory().appendingPathComponent("tune.m4a")
	}

	func startRecording() {
		view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
		recordButton.setTitle("Tap to stop", for: .normal)
		let audioURL = RecordTuneVC.getTuneURL()
		print(audioURL.absoluteString)

		let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
						AVSampleRateKey: 12000,
						AVNumberOfChannelsKey: 1,
						AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]

		do {
			tuneRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
			tuneRecorder.delegate = self
			tuneRecorder.record()
		} catch {
			finishRecording(success: false)
		}
	}

	func finishRecording(success: Bool) {
		view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
		tuneRecorder.stop()
		tuneRecorder = nil

		if success {
			recordButton.setTitle("Tap to Re-record", for: .normal)

			if playButton.isHidden {
				UIView.animate(withDuration: 0.35) { [unowned self] in
					self.playButton.isHidden = false
					self.playButton.alpha = 1
				}
			}

			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
		} else {
			recordButton.setTitle("Tap to Record", for: .normal)
			let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}


	@objc func recordButtonTapped() {
		if tuneRecorder == nil {
			startRecording()
			if !playButton.isHidden {
				UIView.animate(withDuration: 0.35) { [unowned self] in
					self.playButton.isHidden = true
					self.playButton.alpha = 0
				}
			}
		} else {
			finishRecording(success: true)
		}
	}

	@objc func playButtonTapped() {
		let audioURL = RecordTuneVC.getTuneURL()

		do {
			tunePlayer = try AVAudioPlayer(contentsOf: audioURL)
			tunePlayer.play()
		} catch {
			let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}

	@objc func nextTapped() {
		let vc = SelectGenreVC()
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension RecordTuneVC: AVAudioRecorderDelegate {
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		if !flag {
			finishRecording(success: true)
		}
	}
}
