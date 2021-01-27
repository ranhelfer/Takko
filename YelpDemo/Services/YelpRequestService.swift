//
//  YelpRequestService.swift
//  YelpDemo
//
//  Created by rhalfer on 25/01/2021.
//

import SwiftUI
import Combine

class YelpRequestService {
    
    private let apiAuthorizationKeyValue =  "Bearer ag-mjor2Zjhk_SRK-CN-rT3CV9qdCz_2qW6Ss5SW2SqS3ZdzBMosxkfXNSAlV0dPP01Ef3WRY_ptz-FDrIWocdepHYbtfA5jhmOnZw7u89DVPKHuLuZMKxpknY4OYHYx"
    private let apiAuthorizationKey =  "Authorization"
    private let yelpBaseURL = "https://api.yelp.com/v3/businesses/"
    private static let defaultRadius = 8000
    
    func request(latitude: CGFloat,
                 longitude: CGFloat,
                 radius: Int = YelpRequestService.defaultRadius) -> [BusinessModel]?  {
        
        if (latitude == 0 && longitude == 0) {
            /* Obviously we are somewhere bellow africa... no Yelp there :) */
            return nil
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
                let downloadedModels = try decoder.decode(BusinessModels.self, from: data)
                return downloadedModels.businesses
            } catch {
                fatalError("Couldn't parse file")
            }
        }
        return nil
    }
}
