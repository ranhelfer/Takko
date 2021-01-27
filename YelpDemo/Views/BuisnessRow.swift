//
//  BuisnessRow.swift
//  YelpDemo
//
//  Created by rhalfer on 27/01/2021.
//

import SwiftUI

struct BuisnessRow: View {

    let buisness: BusinessModel
    let itemString: String
    @ObservedObject var imageDownloadedService = ImageDownloader()

    var body: some View {
        HStack {
            Image(uiImage: (imageDownloadedService.imageDownloaded ?? UIImage(named: "placeholder"))!)
                .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .scaledToFill()
                .clipShape(Circle())

            Text(itemString)
        }.onAppear(perform: {
            requestImage()
        }).frame(height: 80)
    }
    
    func requestImage() {
        imageDownloadedService.request(imageURLString: buisness.image_url ?? "")
    }
    
}

struct Buisness_Previews: PreviewProvider {
    static var previews: some View {
        BuisnessRow(buisness: BusinessModel.mockModel(), itemString: "")
    }
}
