//
//  BusinessDetailView.swift
//  YelpDemo
//
//  Created by rhalfer on 27/01/2021.
//

import SwiftUI
import MapKit

struct BusinessDetailView: View {
    let business: BusinessModel
    @ObservedObject private var imageDownloadedService = ImageDownloader()
    @State private var region = MKCoordinateRegion()
    @State private var annotationItems = [AnnotationItem]()
    @State var image:UIImage = UIImage()

    var body: some View {
        
        HStack {
            Text(titleForBusiness())
                .font(.headline).foregroundColor(.gray)
            Spacer()
            Text(ratingForBusiness())
                .font(.subheadline).foregroundColor(.yellow)
        }.padding([.leading, .trailing])
        
        ScrollView {
            
            Map(coordinateRegion: $region, annotationItems: annotationItems) { item  in
                MapPin(coordinate: item.coordinate)
            }.frame(height: 150)
            
            Spacer()
            
            Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                .onReceive(imageDownloadedService.objectWillChange, perform: { _ in
                    self.image = (imageDownloadedService.imageDownloaded ?? UIImage(named: "placeholder"))!
                })
                .onAppear(perform: {
                    requestImage()
                    calculateRegion()
                })
        }
               
    }
    
    private func calculateRegion() {
        guard let businessCoordinates = business.coordinates?.coordinates() else {
            return
        }
        region =
            MKCoordinateRegion(center: businessCoordinates,
                               span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.annotationItems.append(AnnotationItem(coordinate: businessCoordinates, business: business))
    }

    private func requestImage() {
        imageDownloadedService.request(imageURLString: business.image_url ?? "")
    }
    
    private func titleForBusiness() -> String {
        if let name = business.name {
            return name
        }
        return ""
    }
    
    private func ratingForBusiness() -> String {
        if let rating = business.rating {
            return "Rated " + String(rating)
        }
        return ""
    }
}

struct BusinessDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailView(business: BusinessModel.mockModel())
    }
}
