//
//  SavedGifsViewController.swift
//  GifMaker
//
//  Created by Abad Vera on 10/18/16.
//  Copyright © 2016 Abad Vera. All rights reserved.
//

import UIKit

var gifsFilePath: String {
    let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let directory = directories.first
    let gifsPath = directory?.appending("/savedGifs")
    return gifsPath!
}


class SavedGifsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PreviewViewControllerDelegate {
    
    var savedGifs: [Gif]? = [Gif]()
    let cellMargin = CGFloat(12.0)
    var isSelectionState = false
    
    // UIBarButtonItems
    var deleteBttnItem: UIBarButtonItem!
    var rightBarItem:UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        self.applyTheme(theme: .Light)
        // Hide if there are no savedGifs
        if let count = savedGifs?.count {
            emptyView.isHidden = count > 0 ? true : false
            self.navigationController?.navigationBar.isHidden = count > 0 ? false : true
            if count > 0 {
                rightBarItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(enableSelectState))
                self.navigationItem.rightBarButtonItem = rightBarItem
                // init other barButtonItems
                deleteBttnItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteGif))
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check to see if we need to show welcome screen
        showWelcome()
        
        createBottomBlur()
        
        if let archGifs = NSKeyedUnarchiver.unarchiveObject(withFile: gifsFilePath) as? [Gif] {
            savedGifs = archGifs
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.title = ""
    }
    
    func showWelcome() {
        if UserDefaults.standard.bool(forKey: "WelcomeViewSeen") != true {
            let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            self.navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
    
    // Create a white blur near bottom of view
    func createBottomBlur() {
        let bottomBlur = CAGradientLayer()
        bottomBlur.frame = CGRect(x: 0.0, y: self.view.frame.size.height - 100.0, width: self.view.frame.size.width, height: 100.0)
        bottomBlur.colors = [UIColor.init(white: 1.0, alpha: 0.0).cgColor, UIColor.white.cgColor]
        self.view.layer.insertSublayer(bottomBlur, above: self.collectionView.layer)
    }
    
    // MARK: PreviewVC Delegate methods
    
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
        gif.gifData = NSData(contentsOf: gif.url as! URL)
        savedGifs?.append(gif)
        // NSKeyedArchiver.archiveRootObject(savedGifs!, toFile: gifsFilePath)
        saveGifs(gifs: savedGifs!)
    }
    
    func saveGifs(gifs: [Gif]) {
        NSKeyedArchiver.archiveRootObject(gifs, toFile: gifsFilePath)
    }
    
    // MARK: CollectionView Delegate and DataSource methods
    
    func enableSelectState() {
        // Add delete barButtonItem to navBar
        if isSelectionState {
            self.navigationItem.leftBarButtonItems?.removeAll()
            rightBarItem.title = "Select"
            cancelSelectedCells(paths: collectionView.indexPathsForSelectedItems)
            isSelectionState = !isSelectionState
            collectionView.allowsMultipleSelection = !isSelectionState
        } else {
            collectionView.allowsMultipleSelection = !isSelectionState
            deleteBttnItem.isEnabled = false
            rightBarItem.title = "Done"
            self.navigationItem.leftBarButtonItem = deleteBttnItem
            isSelectionState = !isSelectionState
        }
    }
    
    // Enable left bar button items when selection is above 0
    func enableBttnItems(cellCount: Int?) {
        guard let count = cellCount else {
            return
        }
        
        if count > 0 {
            deleteBttnItem.isEnabled = true
            
        } else {
            deleteBttnItem.isEnabled = false
        }
    }
    
    // If selection state is canceled then remove all selected items
    func cancelSelectedCells(paths: [IndexPath]?) {
        guard let indexP = paths else {
            return
        }
        for path in indexP {
            collectionView.deselectItem(at: path, animated: true)
            let cell = getCell(path: path)
            cell.selectCell()
        }
    }
    
    // Delete selected gifs
    func deleteGif() {
        let cellsIndexPaths = collectionView.indexPathsForSelectedItems
        for indexP in cellsIndexPaths! {
            let cellToDel = getCell(path: indexP)
            savedGifs = savedGifs?.filter() {$0 != cellToDel.storedGif}
        }
        // First erase stored array then save the modified array
        do {
            try FileManager.default.removeItem(atPath: gifsFilePath)
        } catch {
            print("Error erasing item: \(error)")
        }
        saveGifs(gifs: savedGifs!)
        collectionView.reloadData() // Reload collection view to show removed items
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = savedGifs?.count {
            return count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        cell.configureForGif(gif: savedGifs![indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = savedGifs?[indexPath.item]
        // Check to see if in selection state or not
        if isSelectionState {
            enableBttnItems(cellCount: collectionView.indexPathsForSelectedItems?.count)
            let cell = getCell(path: indexPath)
            cell.selectCell()
            
        } else {
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            
            detailVC.gif = gif
            detailVC.modalPresentationStyle = .overCurrentContext
            present(detailVC, animated: true, completion: nil)
        }
    }
    
    func getCell(path: IndexPath) -> GifCell {
        let cell = collectionView.cellForItem(at: path) as! GifCell
        return cell
    }
    
    // Only deselect cells when in the selection state
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isSelectionState {
            enableBttnItems(cellCount: collectionView.indexPathsForSelectedItems?.count)
            let cell = getCell(path: indexPath)
            cell.selectCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: CollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - (cellMargin * 2)) / 2
        return CGSize(width: width, height: width)
    }
}

