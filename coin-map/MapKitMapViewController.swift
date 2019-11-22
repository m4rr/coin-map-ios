//
//  MapKitMapViewController.swift
//  coin-map
//
//  Created by Marat Saytakov on 21.11.2019.
//  Copyright © 2019 saytakov. All rights reserved.
//

import SwiftUI
import MapKit

class MapKitMapViewController: UIViewController {

  init(coordinator: MapKitMapView.Coordinator) {
    self.coordinator = coordinator

    super.init(nibName: nil, bundle: nil)

    coordinator.controller = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var coordinator: MapKitMapView.Coordinator

  var places: [MKAnnotation] = [] {
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

  var map: MKMapView? {
    return view as? MKMapView
  }

  private func setupLocationButton() {
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

    map?.delegate = coordinator
    map?.mapType = .mutedStandard

    setupLocationButton()
    loadPlaces()
    loadCurrencies()

    registerAnnotationViewClasses()
  }

  private func registerAnnotationViewClasses() {
    //        mapView.register(UnicycleAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    //        mapView.register(BicycleAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    map?.register(BubbleAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    map?.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)

  }

}
