//
//  RootVC.swift
//  audibleClone
//
//  Created by Lahari Ganti on 3/25/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()

    let cellID = "cellID"
    let loginCellID = "loginCellID"
    var page: Page?

    let pages: [Page] = {
        let firstPage = Page(title: "TITLE", message: "Lorem ipsum dolor sit amet, eam etiam graece eirmod eu, an est diam illud placerat. Ex mea dicit nonumes facilisis, his discere placerat assentior id.", imageName: "1")
        let secondPage = Page(title: "TITLE", message: "Lorem ipsum dolor sit amet, eam etiam graece eirmod eu, an est diam illud placerat. Ex mea dicit nonumes facilisis, his discere placerat assentior id.", imageName: "2")
        let thirdPage = Page(title: "TITLE", message: "Lorem ipsum dolor sit amet, eam etiam graece eirmod eu, an est diam illud placerat. Ex mea dicit nonumes facilisis, his discere placerat assentior id.", imageName: "3")
        let fourthPage = Page(title: "TITLE", message: "Lorem ipsum dolor sit amet, eam etiam graece eirmod eu, an est diam illud placerat. Ex mea dicit nonumes facilisis, his discere placerat assentior id.", imageName: "4")
        return [firstPage, secondPage, thirdPage, fourthPage]
    }()

    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .orange
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.numberOfPages = self.pages.count + 1
        return pc
    }()

    let skipButton: UIButton = {
        let sb = UIButton()
        sb.setTitle("Skip", for: .normal)
        sb.setTitleColor(.orange, for: .normal)
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()

    let nextButton: UIButton = {
        let nb = UIButton()
        nb.setTitle("Next", for: .normal)
        nb.setTitleColor(.orange, for: .normal)
        nb.translatesAutoresizingMaskIntoConstraints = false
        return nb
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.view.addSubview(pageControl)
        self.view.addSubview(skipButton)
        self.view.addSubview(nextButton)



        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellID)
        observeKeyboardNotifications()

        setupViews()
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    var pageControlBottomConstraint: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?

    func setupViews() {
        pageControlBottomConstraint = pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        pageControlBottomConstraint?.isActive = true
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true

        skipButtonTopAnchor = skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32)
        skipButtonTopAnchor?.isActive = true
        skipButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        nextButtonTopAnchor = nextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32)
        nextButtonTopAnchor?.isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    @objc func nextButtonPressed() {
        if pageControl.currentPage == pages.count {
            return
        }
        if pageControl.currentPage == pages.count - 1 {
            moveControlConstrainsOffScreen()
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1

    }

    @objc func skipButtonPressed() {
        pageControl.currentPage = pages.count - 1
        nextButtonPressed()
    }


}

extension RootVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == pages.count {
            let loginCell =  collectionView.dequeueReusableCell(withReuseIdentifier: loginCellID, for: indexPath) as! LoginCell
            return loginCell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PageCell
        let page = pages[indexPath.row]
        cell.page = page
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = targetContentOffset.pointee.x / view.frame.width
        pageControl.currentPage = Int(pageNumber)

        if pageControl.currentPage == pages.count {
            moveControlConstrainsOffScreen()
        } else {
            pageControlBottomConstraint?.constant = -20
            skipButtonTopAnchor?.constant = 16
            nextButtonTopAnchor?.constant = 16
        }
    }

    fileprivate func moveControlConstrainsOffScreen() {
        pageControlBottomConstraint?.constant = 100
        skipButtonTopAnchor?.constant = -40
        nextButtonTopAnchor?.constant = -40
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()    
        }
    }
}

extension RootVC: UITextFieldDelegate {
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -90, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }

    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
}
