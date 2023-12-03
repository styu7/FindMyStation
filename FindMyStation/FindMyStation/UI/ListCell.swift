//
//  ListTableViewCell.swift
//  FindMyStation
//
//  Created by YU on 01.12.23.
//

import UIKit

class ListCell: UITableViewCell {
    @IBOutlet weak var stationId: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var power: UILabel!
    
    func set(_ station: Station) {
        self.stationId.text = "Station id: \(station.id)"
        let icon = UIImage(systemName: station.iconName)?.withTintColor(station.iconColor)
        self.availability.addTrailing(image: icon, text: station.availability)
        self.power.text = "Power: \(station.power)"
    }
}

private extension UILabel {
    func addTrailing(image: UIImage?, text: String) {
        let fullString = NSMutableAttributedString(string: "\(text) ")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        attributedText = fullString
    }
}
