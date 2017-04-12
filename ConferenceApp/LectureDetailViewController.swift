//
//  LectureDetailViewController.swift
//  ScheduleApp
//
//  Created by luka on 23/03/2017.
//  Copyright © 2017 luka. All rights reserved.
//

import UIKit

class LectureDetailViewController: UIViewController {
    
    @IBOutlet weak var lectureTitleLabel: UILabel!
    @IBOutlet weak var lecturerNameLabel: UILabel!
    @IBOutlet weak var lectureBioLabel: UILabel!
    @IBOutlet weak var lectureDescritptionLabel: UILabel!
    
    private var lectureTitle: String
    private var lecturerName: String
    private var lecturerBio: String
    private var lectureDescritption: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lectureTitleLabel.text = lectureTitle
        lecturerNameLabel.text = lecturerName
        // Do any additional setup after loading the view.
    }
    
    init(lectureInfo: LectureJson) {
        self.lecturerBio = lectureInfo.lecturer.lecturerName
        self.lectureTitle = lectureInfo.lectureTitle
        self.lecturerName = lectureInfo.lecturer.lecturerShortBio
        self.lectureDescritption = lectureInfo.lectureShortDescription
        
        super.init(nibName: nil, bundle: nil)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @IBAction func deleteEvent(_ sender: UIButton) {
    }

}
