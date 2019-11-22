//
//  MapViewController.swift
//  coin-map
//
//  Created by Marat Saytakov on 21.11.2019.
//  Copyright © 2019 saytakov. All rights reserved.
//

import SwiftUI
import MapKit

class MapViewController: UIViewController {

  init(coordinator: MapRepresentable.Coordinator) {
    self.coordinator = coordinator

    super.init(nibName: nil, bundle: nil)

    coordinator.controller = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var coordinator: MapRepresentable.Coordinator

  var places: [UndetailedAnnotation] = [] {
    didSet {
      guard Thread.isMainThread else {
        return assertionFailure()
      }

      mapView?.addAnnotations(places)
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


  func currenciesFor(placeID: String) -> [Currency] {
    let curplcPairsForThisPlace = currencies_places
      .filter({ (cp) -> Bool in
        cp.placeId == placeID
      })



    let curs = curplcPairsForThisPlace.flatMap({ cp in
      currencies.filter { (c) -> Bool in
        c.id == cp.currencyId
      }
    })

    return curs
  }


  override func loadView() {
    let map = MKMapView()

    view = map
  }

  var mapView: MKMapView? {
    return view as? MKMapView
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
      let decoder = JSONDecoder()
      let items = try decoder.decode([T].self, from: data)

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

      let annotations = places.compactMap { (place) -> UndetailedAnnotation? in
        guard place.visible else {
          return nil
        }

        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)

        return UndetailedAnnotation(coordinate,
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


    mapView?.delegate = coordinator
    mapView?.mapType = .mutedStandard

    registerAnnotationViewClasses()

    loadCurrencies()
    loadPlaces()


  }

  private func registerAnnotationViewClasses() {
    mapView?.register(BubbleAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    
//    mapView?.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
  }

}
