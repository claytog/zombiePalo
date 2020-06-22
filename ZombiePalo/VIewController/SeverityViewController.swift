//
//  SeverityViewController.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import UIKit

class SeverityViewController: UIViewController {

    @IBOutlet weak var illnessLabel: UILabel!
    @IBOutlet weak var illnessImageView: UIImageView!
    
    @IBOutlet weak var severityColView: UICollectionView!
    
    let SEVERITYCOLCELL = "SeverityColCell"
    let HOSPITALLISTSEGUE = "HospitalListSegue"
    
    var selectedIllness: Illness!
    
     var severityList: [Severity]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        illnessLabel.text = selectedIllness.name
        
        severityList = Severity.getAll()
        
        setSeverityCollectionView()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if let destViewController = segue.destination as? HospitalListViewController {
            destViewController.selectedSeverity = sender as? Severity
            destViewController.title = destViewController.selectedSeverity.title
        }
    }

    func setSeverityCollectionView(){
       let cell = UINib(nibName: SEVERITYCOLCELL, bundle: nil)
       severityColView.register(cell, forCellWithReuseIdentifier: SEVERITYCOLCELL)
       
    }

}
extension SeverityViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return severityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 200)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedSeverity  = severityList[indexPath.row]
        performSegue(withIdentifier: HOSPITALLISTSEGUE, sender: selectedSeverity)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index = indexPath.row
        var cell = UICollectionViewCell()
        
        let severity = severityList[index]
        
        let colCell = collectionView.dequeueReusableCell(withReuseIdentifier: SEVERITYCOLCELL, for: indexPath)  as! SeverityColCell

        colCell.setupView(severity: severity)
        
        cell = colCell

        return cell
    }

}
