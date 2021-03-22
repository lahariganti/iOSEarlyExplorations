//
//  HomeVC.swift
//  Record
//
//  Created by Lahari Ganti on 10/7/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import AVFoundation
import CloudKit

class HomeVC: UIViewController {
	var recordButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Tap to record", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.isHidden = false
		button.alpha = 1
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
		return button
	}()

	var playButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Tap to Play", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.isHidden = true
		button.alpha = 0
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
		return button
	}()

	var stackView: UIStackView = {
		let stack = UIStackView()
		stack.spacing = 32
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.distribution = .fillEqually
		stack.alignment = .center
		stack.axis = .vertical
		return stack
	}()

	var recordingSession = AVAudioSession()
	var audioRecorder: AVAudioRecorder!
	var audioPlayer = AVAudioPlayer()
	var spinner = UIActivityIndicatorView()

	override func loadView() {
		view = UIView()
		title = "Record"
		configureNavigationBar()
		view.backgroundColor = .darkBackground
		view.addSubview(stackView)
		setupStackView()
	}

	func configureNavigationBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Recordings", style: .plain, target: self, action: #selector(recordingsButtontapped))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitButtonTapped))
		navigationItem.rightBarButtonItem?.isEnabled = false
	}

	func setupStackView() {
		stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()
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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		if !(isMovingToParent && isBeingPresented) {
			recordButton.setTitle("Tap to Record", for: .normal)
			playButton.isHidden = true
			view.backgroundColor = .darkBackground
		}
	}

	func loadRecordingUI() {
		recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
		playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
		stackView.addArrangedSubviews(recordButton, playButton)
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

	class func getAudioURL() -> URL {
		return getDocumentsDirectory().appendingPathComponent("audio.m4a")
	}

	func startRecording() {
		view.backgroundColor = .recordRed
		recordButton.setTitle("Tap to stop", for: .normal)
		let audioURL = HomeVC.getAudioURL()
		let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
						AVSampleRateKey: 12000,
						AVNumberOfChannelsKey: 1,
						AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]

		do {
			audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
			audioRecorder.delegate = self
			audioRecorder.record()
		} catch {
			finishRecording(success: false)
		}
	}

	func finishRecording(success: Bool) {
		view.backgroundColor = .recordGreen
		audioRecorder.stop()
		audioRecorder = nil
		if success {
			navigationItem.rightBarButtonItem?.isEnabled = true
			recordButton.setTitle("Tap to Re-record", for: .normal)
			if playButton.isHidden {
				UIView.animate(withDuration: 0.35) { [unowned self] in
					self.playButton.isHidden = false
					self.playButton.alpha = 1
				}
			}
		} else {
			recordButton.setTitle("Tap to Record", for: .normal)
			let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your audio; please try again.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}
}

extension HomeVC {
	@objc func recordButtonTapped() {
		if audioRecorder == nil {
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
		let audioURL = HomeVC.getAudioURL()
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
			audioPlayer.play()
		} catch {
			let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your audio; please try re-recording.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}

	@objc func recordingsButtontapped() {
		let vc = RecordingsVC()
		navigationController?.pushViewController(vc, animated: true)
	}

	@objc func submitButtonTapped() {
		let vc = SubmitVC()
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension HomeVC: AVAudioRecorderDelegate {
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		if !flag {
			finishRecording(success: true)
		}
	}
}
