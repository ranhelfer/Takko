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
                .font(.headline)
                .foregroundColor(.gray)
                .font(.title)
                .padding(15)
                .background(RoundedCorners(color: .yellow, tr: 30, bl: 30))
                            
            Spacer()
            Text(ratingForBusiness())
                .font(.subheadline)
                .foregroundColor(.yellow)
                .font(.title)
                .padding(15)
                .background(RoundedCorners(color: .black,
                                           tl: 30,
                                           br: 30))
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


struct RoundedCorners: View {
    /* Nice reference just found at: https://swiftui-lab.com/geometryreader-to-the-rescue/ */
    var color: Color = .black
    var tl: CGFloat = 0.0 // top-left radius parameter
    var tr: CGFloat = 0.0 // top-right radius parameter
    var bl: CGFloat = 0.0 // bottom-left radius parameter
    var br: CGFloat = 0.0 // bottom-right radius parameter
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height
                
                // We make sure the radius does not exceed the bounds dimensions
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                }
                .fill(self.color)
        }
    }
}
