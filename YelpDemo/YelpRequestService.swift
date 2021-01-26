//
//  YelpRequestService.swift
//  YelpDemo
//
//  Created by rhalfer on 25/01/2021.
//

import SwiftUI
import Combine

class YelpRequestService {
    
    private var apiAuthorizationKeyValue =  "Bearer ag-mjor2Zjhk_SRK-CN-rT3CV9qdCz_2qW6Ss5SW2SqS3ZdzBMosxkfXNSAlV0dPP01Ef3WRY_ptz-FDrIWocdepHYbtfA5jhmOnZw7u89DVPKHuLuZMKxpknY4OYHYx"
    private var apiAuthorizationKey =  "Authorization"
    private var yelpBaseURL = "https://api.yelp.com/v3/businesses/"
    private(set) var downloadedModel: BusinessModels?
        
    func request(latitude: CGFloat,
                 longitude: CGFloat,
                 radius: Int = 8000) {
        if (latitude == 0 && longitude == 0) {
            return
        }
        
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: yelpBaseURL+"search?latitude=\(latitude)&longitude=\(longitude)&radius=\(radius)")!,timeoutInterval: Double.infinity)
        
        request.addValue(apiAuthorizationKeyValue, forHTTPHeaderField: apiAuthorizationKey)
        request.httpMethod = "GET"
        
        var downloadedData: Data?

        let task = URLSession.shared.dataTask(with: request) {  data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }

            downloadedData = data
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        if let data = downloadedData {
            do {
                let decoder = JSONDecoder()
                downloadedModel = try decoder.decode(BusinessModels.self, from: data)
            } catch {
                fatalError("Couldn't parse file")
            }
        }
    }
}
