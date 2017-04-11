//
//  EventTableViewCell.swift
//  ConferenceApp
//
//  Created by luka on 10/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension EventTableViewCell {
    func configure(for event: Event) {
        self.textLabel?.text = event.eventName
    }
}
