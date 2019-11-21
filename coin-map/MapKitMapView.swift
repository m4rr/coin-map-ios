//
//  MapKitMapViewController.swift
//  coin-map
//
//  Created by Marat Saytakov on 16.11.2019.
//  Copyright © 2019 saytakov. All rights reserved.
//

import SwiftUI
import MapKit

class UndetailedPointAnnotation: MKPointAnnotation {

  /// Wouldn't be shown on the map, but would be provided as data.
  let hiddenSubtitle: String

  let phone, website, hours, placeID: String

  init(_ coo: CLLocationCoordinate2D,
       title: String, subtitle: String,
       phone: String, website: String, hours: String,
       placeID: String) {

    self.hiddenSubtitle = subtitle

    self.phone = phone
    self.website = website
    self.hours = hours
    self.placeID = placeID

    super.init()

    self.title = title
    self.coordinate = coo
  }
}

class MapKitMapViewController: UIViewController {

  var coordinator: MapKitMapView.Coordinator!

  var places: [MKPointAnnotation] = [] {
    didSet {
      guard Thread.isMainThread else {
        return assertionFailure()
      }

      map?.addAnnotations(places)
    }
  }

  var currencies: [Currency] = [] {
    didSet {
      //
    }
  }

  var currencies_places: [CurrencyPlace] = [] {
    didSet {
      //
    }
  }

  override func loadView() {
    let map = MKMapView()

    view = map
  }

  private var map: MKMapView? {
    return view as? MKMapView
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    map?.delegate = coordinator

    setupLocationButton()
  }

  func setupLocationButton() {
    return;

    //    let button = MKUserTrackingButton(mapView: map)
    //    button.layer.backgroundColor = UIColor.white.cgColor
    //    button.layer.borderColor = UIColor.blue.cgColor
    //    button.layer.borderWidth = 1
    //    button.tintColor = .black

    //    map.addSubview(button)
    //
    //    button.translatesAutoresizingMaskIntoConstraints = false
    //    button.bottomAnchor.constraint(equalTo: map.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    //    button.centerXAnchor.constraint(equalTo: map.centerXAnchor).isActive = true
    //
    //    button.setNeedsLayout()
    //
    //    button.layer.cornerRadius = button.bounds.midY
  }

  private func loadCurrencies() {
    DispatchQueue.global().async {
      let curs: [Currency] = self.loadItems(filename: "currencies")

      DispatchQueue.main.async {
        self.currencies = curs
      }
    }

    DispatchQueue.global().async {
      let curplcs: [CurrencyPlace] = self.loadItems(filename: "currencies_places")

      DispatchQueue.main.async {
        self.currencies_places = curplcs
      }
    }
  }

  private func loadItems<T: Codable>(filename: String) -> [T] {
    guard let placesDataFileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
      return []
    }

    do {
      let data = try Data(contentsOf: placesDataFileURL)
      let items = try JSONDecoder().decode([T].self, from: data)

      debugPrint(items.count)

      return items

    } catch {
      debugPrint(error)

      return []
    }
  }

  private func loadPlaces() {
    DispatchQueue.global().async {
      let places: [Place] = self.loadItems(filename: "places")

      let annotations = places.compactMap { (place) -> UndetailedPointAnnotation? in
        guard place.visible else {
          return nil
        }

        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)

        return UndetailedPointAnnotation(coordinate,
                                         title: place.name,
                                         subtitle: place.description,
                                         phone: place.phone,
                                         website: place.website,
                                         hours: place.openingHours,
                                         placeID: place.id)
      }

      DispatchQueue.main.async {
        self.places = annotations
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    loadPlaces()
    loadCurrencies()
  }

}

struct MapKitMapView: UIViewControllerRepresentable {

  @Binding var selected: Bool
  @Binding var title: String
  @Binding var subtitle: String
  @Binding var phone: String
  @Binding var website: String
  @Binding var hours: String

  @Binding var placeCurrencies: [Currency]

  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }


  func makeUIViewController(context: UIViewControllerRepresentableContext<MapKitMapView>) -> MapKitMapViewController {
    let mkmpvc = MapKitMapViewController()
    mkmpvc.coordinator = context.coordinator
    context.coordinator.controller = mkmpvc
    return mkmpvc
  }

  func updateUIViewController(_ uiViewController: MapKitMapViewController, context: UIViewControllerRepresentableContext<MapKitMapView>) {
    //
  }

  class Coordinator: NSObject, MKMapViewDelegate {

    var parent: MapKitMapView
    weak var controller: MapKitMapViewController?

    init(_ c: MapKitMapView) {
      parent = c

      super.init()
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {

    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      guard let placeAnno = view.annotation as? UndetailedPointAnnotation else {
        return
      }

      parent.selected = true
      parent.title = placeAnno.title ?? ""
      parent.subtitle = placeAnno.hiddenSubtitle

      parent.phone = placeAnno.phone
      parent.website = placeAnno.website
      parent.hours = placeAnno.hours

      guard let controller = controller else { return }


      let curplcPairsForThisPlace = controller.currencies_places
        .filter({ (cp) -> Bool in
          cp.placeId == placeAnno.placeID
        })



      let curs = curplcPairsForThisPlace.flatMap({ cp in
        controller.currencies.filter { (c) -> Bool in
          c.id == cp.currencyId
        }
      })

      parent.placeCurrencies = curs
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
      parent.selected = false
    }

  }

}
