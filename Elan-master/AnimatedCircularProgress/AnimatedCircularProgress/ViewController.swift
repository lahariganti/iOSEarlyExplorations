//
//  ViewController.swift
//  AnimatedCircularProgress
//
//  Created by Lahari Ganti on 3/31/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
    var shapeLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()

    var pulsatingLayer = CAShapeLayer()

    let circularPath = UIBezierPath(arcCenter: .zero, radius: 80, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

    private func createLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.lineCap = .round
        layer.fillColor = fillColor.cgColor
        layer.position = view.center
        return layer
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor

        setupLayers()
        setupPercentageLabel()
    }

    private func setupLayers() {
        pulsatingLayer = createLayer(strokeColor: UIColor.clear, fillColor: UIColor.pulsatingFillColor)
        animatingPulsatingLayer()

        trackLayer = createLayer(strokeColor: UIColor.trackStrokeColor, fillColor: UIColor.backgroundColor)

        shapeLayer = createLayer(strokeColor: UIColor.outlineStrokeColor, fillColor: UIColor.clear)
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)

        for layer in [pulsatingLayer, trackLayer, shapeLayer] {
            view.layer.addSublayer(layer)
        }
    }

    private func setupPercentageLabel() {
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(objectTapped)))
    }

    private func animatingPulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsating")
    }

    private func beginDownloading() {
        shapeLayer.strokeEnd = 0
        print("downloading")
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        guard let string = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: string)
        downloadTask.resume()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("done downloading")
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(totalBytesWritten, totalBytesExpectedToWrite)
        let percentage = CGFloat(totalBytesWritten)  / CGFloat(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = percentage
            self.percentageLabel.text = "\(Int(percentage * 100)) %"
        }
    }

    fileprivate func animateCircle() {
        let basicANimation = CABasicAnimation(keyPath: "strokeEnd")
        basicANimation.toValue = 1
        basicANimation.duration = 2
        basicANimation.fillMode = .forwards
        basicANimation.isRemovedOnCompletion = false
        shapeLayer.add(basicANimation, forKey: "basic")
    }

    @objc func objectTapped() {
        beginDownloading()
    }
}
