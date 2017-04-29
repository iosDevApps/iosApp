//
//  EventService.swift
//  ConferenceApp
//
//  Created by luka on 22/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation

class EventService {
    private var handler: ([EventJson]) -> Void = { events in }
    
    func getEvents(handler: @escaping ([EventJson]) -> Void) {
        self.handler = handler
        let jsonService = JsonService()
        jsonService.get(url: "http://138.68.104.189/events", handler: handleData)
    }
    
    private func handleData(data: Data) {
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
            let events = parsedData.flatMap(EventJson.init)
            handler(events)
        } catch {
            print(error)
        }
    }
    
}
