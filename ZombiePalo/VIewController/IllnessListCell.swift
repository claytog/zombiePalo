//
//  TableViewCell.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import UIKit

class IllnessListCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
extension IllnessListCell {
    
    func setupView(illness: Illness){
        
        cellLabel.text = illness.name
        
        if let image = UIImage(named: illness.name) {
            cellImageView.image = image
        }
    }
    
}
