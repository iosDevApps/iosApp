//
//  DailyScheduleViewCell.swift
//  ScheduleApp
//
//  Created by luka on 15/03/2017.
//  Copyright © 2017 luka. All rights reserved.
//

import UIKit
import PureLayout

class DailyScheduleViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(lectureInfo: LectureJson) {
        
        let lectureTitleLabel = UILabel()
        let lectureLecturer = UILabel()
        let lectureScheduledTime = UILabel()
        let lectureLocation = UILabel()
        
        lectureTitleLabel.text = lectureInfo.title
        lectureLecturer.text = lectureInfo.lecturer.name
        lectureScheduledTime.text = lectureInfo.scheduledTime
        lectureLocation.text = lectureInfo.location
        
        self.addSubview(lectureTitleLabel)
        self.addSubview(lectureLecturer)
        self.addSubview(lectureScheduledTime)
        self.addSubview(lectureLocation)
        
        lectureTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        lectureTitleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        
        lectureLecturer.autoPinEdge(.top, to: .bottom, of: lectureTitleLabel, withOffset: 10)
        lectureLecturer.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        lectureLecturer.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        
        lectureScheduledTime.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        lectureScheduledTime.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        
        lectureLocation.autoPinEdge(.top, to: .bottom, of: lectureScheduledTime, withOffset: 10)
        lectureLocation.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        lectureLocation.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        
        
    }
}
    

