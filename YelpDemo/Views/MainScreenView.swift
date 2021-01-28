//
//  MainScreenView.swift
//  YelpDemo
//
//  Created by rhalfer on 25/01/2021.
//

/*
 
    Still have issues like how to use correctly dispatch queues and not run everything on main thread
    
 
 */
import SwiftUI
import MapKit

struct MainScreenView: View {
    
    @ObservedObject var locationManager = LocationManager()

    /* You use the @State attribute to establish a source of truth for data in your app that you can modify from more than one view. SwiftUI manages the underlying storage and automatically updates views that depend on the value. */
    @State private var region = MKCoordinateRegion()
    @State private var businesses = [BusinessModel]()
    @State private var annotationItems = [AnnotationItem]()
    @State private var selectedBusiness: BusinessModel?

    static let filterType = ["Geo-Location", "Search", "Sort by Distance", "Sort by Rating"]
    @State var selectedFilterType = 2
    @State var searchByKeyText = ""
    @State var inputLatitude = ""
    @State var inputLongitude = ""

    private var dragGesture = DragGesture()
    private let currentSpan = 0.07
    
    var sortedBusinesses: [BusinessModel] {
        /* Return the desired filter here */
        if selectedFilterType == 0 {
            
        }
        if selectedFilterType == 1 {
            if searchByKeyText.isEmpty {
                return businesses
            }
            return businesses.filter { (model) -> Bool in
                for category in model.categories {
                    if let title = category.title {
                        if title.contains(searchByKeyText) {
                            return true
                        }
                    }
                    if let alias = category.alias {
                        if alias.contains(searchByKeyText) {
                            return true
                        }
                    }
                }
                return (model.name?.contains(searchByKeyText) ?? false)
            }
        }
        if selectedFilterType == 2 {
            return businesses.sorted(by: { $0.distance ?? 0 < $1.distance ?? 0})
        }
        return businesses.sorted(by: { $0.rating ?? 0 > $1.rating ?? 0})
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker("Show Location By:", selection: $selectedFilterType) {
                        ForEach(0 ..< Self.filterType.count) { index in
                            Text(Self.filterType[index])
                        }
                    }
                    if selectedFilterType == 1 {
                        TextField("Enter Search Text Here", text: $searchByKeyText)
                    }
                    if selectedFilterType == 0 {
                        HStack {
                            Spacer()
                            TextField("Latitude \(region.center.latitude)", text: $inputLatitude, onCommit: didPressReturnLatitude)
                            Spacer()
                            TextField("Longitude \(region.center.longitude)", text: $inputLongitude, onCommit: didPressReturnLongitude)
                            Spacer()
                        }.keyboardType(.numbersAndPunctuation)
                    }
                }.frame(height: self.showingTextFields() ? 150 :  /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .top)
                                
                Map(coordinateRegion: $region, annotationItems: annotationItems) { item  in
                    MapPin(coordinate: item.coordinate)
                }.onTapGesture {
                    hitService()
                }
                
                CurrentLocationView(region: $region)
                
                List {
                    ForEach(self.sortedBusinesses) { business in
                        BusinessRow(business: business, itemString: self.stringForFilter(business: business))
                    }
                }
                Spacer()
            }.onReceive(self.locationManager.objectWillChange, perform: { _ in
                handleOnRecieveEvent()
            })
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func showingTextFields() -> Bool {
        return selectedFilterType == 0 || selectedFilterType == 1
    }
    
    func stringForFilter(business: BusinessModel) -> String {
        var str = "\(business.name ?? "")  distance \(Int(business.distance ?? 0)) [m]"
        if self.selectedFilterType == 3 {
            str = "\(business.name ?? "")  rating \(business.rating ?? 0)"
        }
        return str
    }
    
    func didPressReturnLatitude() {
        evaluateInputGeoLocations()
    }
    
    func didPressReturnLongitude() {
        evaluateInputGeoLocations()
    }
    
    private func evaluateInputGeoLocations() {
        let inputLatitudeFloatVal = (self.inputLatitude as NSString).floatValue
        let inputLongitudeFloatVal = (self.inputLongitude as NSString).floatValue
        
        /* We int this since otherwise the system refer to this as -0.0 */
        guard Int(inputLatitudeFloatVal) != 0 && Int(inputLongitudeFloatVal) != 0 else {
            return
        }
        
        print("ranh latitude=\(inputLatitudeFloatVal) longitude=\(inputLongitudeFloatVal)")
        
        let selectedCenter:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(inputLatitudeFloatVal),
                                                                           longitude: Double(inputLongitudeFloatVal))
        region = MKCoordinateRegion(
                    center: selectedCenter,
                    span: MKCoordinateSpan(latitudeDelta: currentSpan, longitudeDelta: currentSpan))
        
        hitService()
    }
    
    private func handleOnRecieveEvent() {
        guard shouldSetRegion() else {
            return
        }
        
        setRegion()
        hitService()
    }
    
    private func hitService() {
        let service = YelpRequestService()
        
        if let serviceRequestBusinesses = service.request(latitude: CGFloat(region.center.latitude), longitude: CGFloat(region.center.longitude)) {
            self.businesses = serviceRequestBusinesses
            
            for business in self.businesses {
                if let coordinate = business.coordinates?.coordinates() {
                    self.annotationItems.append(AnnotationItem(coordinate: coordinate, business: business))
                }
            }
        }
    }
    
    private func locationManagerCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0, longitude: locationManager.lastLocation?.coordinate.longitude ?? 0)
    }
    
    private func shouldSetRegion() -> Bool {
        let newCoordinate = locationManagerCoordinate()
        if region.center.latitude == newCoordinate.latitude &&
            region.center.longitude == newCoordinate.longitude {
            return false
        }
    
        guard selectedFilterType != 0 else {
                return false
        }
        
        return true
    }
    
    private func setRegion() {
        region = MKCoordinateRegion(
                    center: locationManagerCoordinate(),
                    span: MKCoordinateSpan(latitudeDelta: currentSpan, longitudeDelta: currentSpan))
        
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainScreenView()
        }
    }
}
