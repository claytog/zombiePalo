//
//  TableViewCell.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import UIKit

class HospitalListCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var waitTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

}
extension HospitalListCell {
    
    func setupView(hospital: Hospital, severity: Severity){
        
        hospitalNameLabel.text = hospital.name
        if let image = UIImage(named: hospital.name) {
            cellImageView.image = image
        }else{
            cellImageView.image = UIImage(named: "nswlogo")
            cellImageView.alpha = 0.3
        }
        
        if let waitTime = hospital.getWaitTime(severity: severity) {
            let waitLabel = Util.shared.displayHourMin(minutes: waitTime)
            waitTimeLabel.text = waitLabel
            if waitTime == 0 {
                waitTimeLabel.textColor = UIColor.systemGreen
            }else{
                waitTimeLabel.textColor = UIColor.purple
            }
        
        }else{
            waitTimeLabel.text = "INUNDATED"
        }
    }
    
}
