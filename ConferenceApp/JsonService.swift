//
//  JsonService.swift
//  ConferenceApp
//
//  Created by Admin on 15/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class JsonService {
    private let session = URLSession(configuration: .default)
    private var handler: (Data) -> Void = { data in }
    
    public func get(url: String, handler: @escaping (Data) -> Void) {
        self.handler = handler
        DispatchQueue.global().async {
            guard let apiUrl = URL(string: url) else {
                print("Error loading URL")
                return
            }
            // resume() used because a DataTask is created in suspended state
            self.session
                .dataTask(with: apiUrl, completionHandler: self.handleData)
                .resume()
        }
    }

    // handling the data from the DataTask
    private func handleData(rawData: Data?, rawURLResponse: URLResponse?, rawError: Error?) {
        if let error = rawError {
            print(error)
            return
        }
        guard let data = rawData else {
            print("no data recieved")
            return
        }
        
        //guard data.count != 0 else { return }
        
        if(data.count != 0) {
            self.handler(data)
        }
    }

}
