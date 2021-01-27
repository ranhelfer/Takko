//
//  BusinessRow.swift
//  YelpDemo
//
//  Created by rhalfer on 27/01/2021.
//

import SwiftUI

struct BusinessRow: View {

    let business: BusinessModel
    let itemString: String
    @ObservedObject var imageDownloadedService = ImageDownloader()

    var body: some View {
        NavigationLink(destination: BusinessDetailView(business: business)) {
            HStack {
                Image(uiImage: (imageDownloadedService.imageDownloaded ?? UIImage(named: "placeholder"))!)
                    .frame(width: 80, height: 80)
                    .scaledToFill()
                    .clipShape(Circle())
                
                Text(itemString)
            }.onAppear(perform: {
                requestImage()
            }).frame(height: 80)
        }
    }
    
    func requestImage() {
        imageDownloadedService.request(imageURLString: business.image_url ?? "")
    }
    
}

struct BusinessRow_Previews: PreviewProvider {
    static var previews: some View {
        BusinessRow(business: BusinessModel.mockModel(), itemString: "")
    }
}
