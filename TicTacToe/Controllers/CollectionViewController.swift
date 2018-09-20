//
//  ViewController.swift
//  TicTacToe
//
//  Created by Amit  Singh on 9/20/18.
//  Copyright © 2018 singhamit089. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 10
    let minimumInteritemSpacing: CGFloat = 10
    var cellsPerRow:Int!
    var gameBoardSize:Int!
    var gameObject:TicTacToe!

    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView?.register(UINib(nibName: "TTTCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TTTCollectionViewCell")
        
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "Board Size", style: UIBarButtonItemStyle.done, target: self, action: #selector(buttonBoardSizeOnTap))
        
        startGameWith(boardSize: 3)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.userWonTheGame),
            name: NSNotification.Name("userWonTheGame"),
            object: nil)
    }
    
    func startGameWith(boardSize:Int) {
        
        gameBoardSize = boardSize
        self.cellsPerRow = self.gameBoardSize
        gameObject = TicTacToe(boardSize: self.gameBoardSize)
        self.collectionView?.reloadData()
    }
    
    @objc func userWonTheGame() {
        
        let alertController = UIAlertController(title: "Game Won!", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) in
            self.startGameWith(boardSize: self.gameBoardSize)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func buttonBoardSizeOnTap() {
        
        let alertController = UIAlertController(title: "Board Size", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Board Size"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            
            let size = Int(textField.text ?? "3") ?? 3
            
            self.startGameWith(boardSize: size)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameBoardSize*gameBoardSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TTTCollectionViewCell", for: indexPath) as! TTTCollectionViewCell
        
        let value:Int = gameObject.matrix[indexPath.row/self.gameBoardSize][indexPath.row % self.gameBoardSize]
        
        if value == 0 {
            cell.labelType.text = "O"
        }else if value == 1 {
            cell.labelType.text = "X"
        }else{
            cell.labelType.text = ""
        }
        
        cell.backgroundColor = UIColor.yellow
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var currentCellValue:Int = gameObject.matrix[indexPath.row/self.gameBoardSize][indexPath.row % self.gameBoardSize]
        
        if currentCellValue != InputType.l.rawValue || gameObject.gameWon {
            return
        }
        
        self.gameObject.userInput(with: Input(coridnates: Cordinates(xCordinates: indexPath.row/self.gameBoardSize, yCordinates: indexPath.row % self.gameBoardSize), type: gameObject.lastMove))
        
        collectionView.reloadItems(at: [indexPath])
    }
}

extension CollectionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
//    - (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
//
//    // returns the # of rows in each component..
//    - (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
}

