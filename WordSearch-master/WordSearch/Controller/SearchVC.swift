//
//  SearchVC.swift
//  WordSearch
//
//  Created by Lahari Ganti on 5/7/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import TagListView

class SearchVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var wordsToSearchView: TagListView!
    @IBOutlet weak var selectedWordLabel: UILabel!

    private let reuseIdentifier = "LetterCell"

    var allIndicies: Set<IndexPath> = []
    var selectedWord = Word(text: "")
    var allLabels = [Label]()
    lazy var wordsToSearch = [String]()

    var initialIndexPath: IndexPath?
    var finalIndexPath: IndexPath?

    var tagViewsCount: Int = 0
    let selectedCategory: Category

    let defaultDifficulty: Difficulty = .easy

    init(selectedCategory: Category) {
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCategory.name
        setupCollectionView()
        configureCollectionView()
        createGridFromJSON(difficulty: defaultDifficulty)
        wordsToSearchView.addTags(wordsToSearch)
        configureNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }

    func createGridFromJSON(difficulty: Difficulty) {
        guard let path = Bundle.main.url(forResource: selectedCategory.name.lowercased(), withExtension: "json") else { return }
        guard let contents = try? Data(contentsOf: path) else { return }
        guard let words = try? JSONDecoder().decode([Word].self, from: contents) else { return }

        let wordSearch = WordSearch(difficulty: difficulty)
        wordSearch.words = words
        wordsToSearch = wordSearch.words.map({$0.text.uppercased()})

        tagViewsCount = wordsToSearch.count
        wordSearch.createGrid()

        allLabels = Array(wordSearch.labels.joined())
    }
}

private extension SearchVC {
    func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Difficulty", style: .plain, target: self, action: #selector(didPressDifficultyButton))
    }

    func setupCollectionView() {
        view.backgroundColor = .lemmaRed
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: (collectionView.frame.width/11) - 8, height: (collectionView.frame.width/11))
        }
    }

    func configureCollectionView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        panGesture.delegate = self
        collectionView.addGestureRecognizer(panGesture)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.canCancelContentTouches = true
        collectionView.allowsSelection = false
    }

    func isGameOver() {
        if tagViewsCount == 0 {
//            TODO refactor this ugly chunk
            let alert = UIAlertController(title: "OH YA", message: "Done with this category", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "All Categories", style: .default, handler: { action in
                self.navigationController?.popToRootViewController(animated: true)
            }))

            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension SearchVC {
//    TODO refactor this ugly chunk
//     Alert.difficultyButtonAlert(on: self, with: "Difficulty", message: "Let's see what you got")

    @objc func didPressDifficultyButton() {
        let alert = UIAlertController(title: "Difficulty", message: "Let's see what you got", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Easy (default)", style: .default, handler: { action in
            self.createGridFromJSON(difficulty: self.defaultDifficulty)
            self.reloadRequiredSubviews()
        }))

        alert.addAction(UIAlertAction(title: "Medium", style: .default, handler: { action in
            self.createGridFromJSON(difficulty: Difficulty.medium)
            self.reloadRequiredSubviews()
        }))

        alert.addAction(UIAlertAction(title: "Hard", style: .default, handler: { action in
            self.createGridFromJSON(difficulty: Difficulty.hard)
            self.reloadRequiredSubviews()
        }))

        self.present(alert, animated: true, completion: nil)
    }

    func reloadRequiredSubviews() {
//        change this hack
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view)
    }
}

extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allLabels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LetterCell
        cell.configure(with: allLabels[indexPath.row])
        return cell
    }
}

extension SearchVC: UIGestureRecognizerDelegate, UICollectionViewDelegate {
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard let index = collectionView.indexPathForItem(at: location) else { return }
        guard let _ = gesture.direction else { return }

        let allIndicesCount = allIndicies.count
        allIndicies.insert(index)

//      want to get rid of this but couldn't make the bezier path continous without running into multiple issues
        collectionView.cellForItem(at: index)?.backgroundColor = .lemmaYellow

        switch gesture.state {
            case .began:
                initialIndexPath = index
                addLettersWhilePanning(index: index)
                selectedWordLabel.alpha = 1.0
            
            case .changed:
                if allIndicies.count > allIndicesCount {
                    addLettersWhilePanning(index: index)
                }

            case .ended:
                finalIndexPath = index

                if initialIndexPath != nil && finalIndexPath != nil {
                    if selectedWordIsWordToSearch() {
                        collectionView.drawLineFrom(from: initialIndexPath!, to: finalIndexPath!, strokeColor: .lemmaBlue)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1/2)) {
                            if let selectedWord = self.selectedWordLabel.text {
                                UIView.animate(withDuration: 0.8) {
                                    self.wordsToSearchView.removeTag(selectedWord)
                                }
                            }
                        }
                        tagViewsCount = wordsToSearchView.tagViews.count - 1
                    } else {
                        collectionView.drawLineFrom(from: initialIndexPath!, to: finalIndexPath!, strokeColor: .lemmaRed)
                        removeBezierPath()
                    }
                }

                clearSelectedCellColor()
                clearSelectedWord()
                isGameOver()

            case .cancelled:
                print("cancelled")

            default: break
        }
    }
}

extension SearchVC {
//    TODO clear letter when direction changes 
    func addLettersWhilePanning(index: IndexPath) {
        let selectedLetter = allLabels[index.row].letter
        selectedWord.text.append(selectedLetter)
        selectedWordLabel.alpha = 1
        selectedWordLabel.text?.append(selectedLetter)
    }

    func clearSelectedWord() {
        if selectedWordIsWordToSearch() {
            selectedWordLabel.fadeOut()
        } else {
            selectedWordLabel.shake(count: 2, for: 0.2, withTranslation: 2)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.selectedWordLabel.text = ""
            self.selectedWordLabel.alpha = 0
        }

        selectedWord.text = ""
        allIndicies = []
    }

    func removeBezierPath() {
        guard let collectionViewSublayers = collectionView.layer.sublayers else { return }
        guard let lastLayer = collectionViewSublayers.last else { return }
        if lastLayer is CAShapeLayer  {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                lastLayer.removeFromSuperlayer()
            }
        }
    }

    func clearSelectedCellColor() {
        let indicesArray = Array(allIndicies)

        indicesArray.forEach { (i) in
            self.collectionView.cellForItem(at: i)?.backgroundColor = .clear
        }

        self.collectionView.reloadItems(at: indicesArray)
    }

    func selectedWordIsWordToSearch() -> Bool {
        let returnValue = wordsToSearch.contains(selectedWord.text)
        return returnValue
    }
}
