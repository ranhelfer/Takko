//
//  BusinessModel.swift
//  YelpDemo
//
//  Created by rhalfer on 26/01/2021.
//

import Foundation
import MapKit

struct BusinessModels: Hashable, Codable {
    let businesses: [BusinessModel]
}

struct BusinessModel: Hashable, Codable, Identifiable {
    let id: String
    let name: String?
    let image_url: String?
    let is_closed: Bool?
    
    let review_count: Int?
    let categories: [BusinessModelCategory]
    let rating: Double?
    let coordinates: BusinessModelCoordinates?
    let distance: Double?
    
    static func mockModel() -> BusinessModel {
        return BusinessModel(id: "",
                             name: "Super Duper Hamburger",
                             image_url: "",
                             is_closed: false,
                             review_count: 0,
                             categories: [],
                             rating: 1,
                             coordinates: nil,
                             distance: 0)
    }
}

struct BusinessModelCoordinates: Hashable, Codable {
    let latitude: Double?
    let longitude: Double?
    
    func coordinates() -> CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
    }
}

struct BusinessModelCategory: Hashable, Codable {
    let alias: String?
    let title: String?
}



/*
{
    "businesses": [
        {
            "id": "Xg-FyjVKAN70LO4u4Z1ozg",
            "alias": "hog-island-oyster-co-san-francisco",
            "name": "Hog Island Oyster Co",
            "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/TW9FgV_Ufqd15t_ARQuz1A/o.jpg",
            "is_closed": false,
            "url": "https://www.yelp.com/biz/hog-island-oyster-co-san-francisco?adjust_creative=uw5lqh5iTyl9hZbhWSZ-Nw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=uw5lqh5iTyl9hZbhWSZ-Nw",
            "review_count": 6094,
            "categories": [
                {
                    "alias": "seafood",
                    "title": "Seafood"
                },
                {
                    "alias": "seafoodmarkets",
                    "title": "Seafood Markets"
                },
                {
                    "alias": "raw_food",
                    "title": "Live/Raw Food"
                }
            ],
            "rating": 4.5,
            "coordinates": {
                "latitude": 37.795831,
                "longitude": -122.393303
            },
            "transactions": [],
            "price": "$$",
            "location": {
                "address1": "1 Ferry Bldg",
                "address2": "",
                "address3": "Shop 11",
                "city": "San Francisco",
                "zip_code": "94111",
                "country": "US",
                "state": "CA",
                "display_address": [
                    "1 Ferry Bldg",
                    "Shop 11",
                    "San Francisco, CA 94111"
                ]
            },
            "phone": "+14153917117",
            "display_phone": "(415) 391-7117",
            "distance": 1154.8167382059307
        },
        
    "total": 6300,
    "region": {
        "center": {
            "longitude": -122.399972,
            "latitude": 37.786882
        }
    }
}
*/
