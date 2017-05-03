//
//  ScheduleService.swift
//  ConferenceApp
//
//  Created by luka on 02/05/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation

class ScheduleService {
    private var handler: (ScheduleJson) -> Void = { schedule in }
    
    func getSchedule(for eventId: String, handler: @escaping (ScheduleJson) -> Void) {
        self.handler = handler
        let jsonService = JsonService()
        jsonService.get(url: "http://138.68.104.189/events/\(eventId)", handler: handleData)
    }
    
    private func handleData(data: Data) {
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            let schedule = ScheduleJson(scheduleInfo: parsedData["schedule"] as! [[String : Any]])!
            handler(schedule)
        } catch {
            print(error)
        }
    }
}
