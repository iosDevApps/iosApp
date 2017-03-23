//
//  CalendarViewCell.swift
//  ScheduleApp
//
//  Created by luka on 15/03/2017.
//  Copyright © 2017 luka. All rights reserved.
//

import UIKit

class CalendarViewCell: UITableViewCell {

    var lectureTitleLabel = UILabel()
    var lectureLecturer = UILabel()
    var lectureScheduledTime = UILabel()
    var lectureLocation = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func setupCell(lectureInfo: Lecture) {
        
        lectureTitleLabel.text = lectureInfo.lectureTitle
        lectureLecturer.text = lectureInfo.lecturerName
        lectureScheduledTime.text = lectureInfo.lectureScheduledTime
        lectureLocation.text = lectureInfo.lectureLocation
//        lectureTitleLabel.text
    }
}
    

