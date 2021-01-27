//
//  ImageDownloader.swift
//  YelpDemo
//
//  Created by rhalfer on 27/01/2021.
//

import Foundation
import SwiftUI
class ImageDownloader: NSObject, ObservableObject {
    
    @Published var imageDownloaded: UIImage? {
        didSet {
            objectWillChange.send()
        }
    }
    
    func request(imageURLString: String) {
        guard let url = URL(string:imageURLString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if error == nil && data != nil && !data!.isEmpty{
                DispatchQueue.main.async { [weak self] in
                    self?.imageDownloaded = UIImage(data: data!)
                }
            }
        }
        
        task.resume()
        
    }
}
