//
//  SeverityColCell.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//
import Foundation

import UIKit

class SeverityColCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerBorderView: UIView!
    
    @IBOutlet weak var severityLabel: UILabel!
    @IBOutlet weak var severityImageView: UIImageView!

    let severityImages = [ #imageLiteral(resourceName: "Winking-Smiley-Face"),#imageLiteral(resourceName: "Vulnerable-Smiley-Face"),#imageLiteral(resourceName: "Petrified-Smiley-Face-Silhouette"),#imageLiteral(resourceName: "Mentally-Deranged-Smiley-Face-Silhouette")]
    
    var selectedSeverity: Severity?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }

}

extension SeverityColCell {
  
    func setupView(severity: Severity) {
        severityLabel.text = severity.title
        let lop = severity.levelOfPain - 1
        if lop < severityImages.count {
            severityImageView.image = severityImages[lop]
        }
        severityImageView.setRounded()
    }
    
}
 

