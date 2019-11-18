//
//  MapKitMapViewController.swift
//  coin-map
//
//  Created by Marat Saytakov on 16.11.2019.
//  Copyright © 2019 saytakov. All rights reserved.
//

import SwiftUI
import MapKit

class MapKitMapViewController: UIViewController {

  var delegate: MKMapViewDelegate!

  var places: [MKPointAnnotation] = [] {
    didSet {
      guard Thread.isMainThread else {
        return assertionFailure()
      }

      map?.addAnnotations(places)
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

  private func loadPlaces() {
    guard let placesDataFileURL = Bundle.main.url(forResource: "places", withExtension: "json") else {
      return
    }

    DispatchQueue.global().async {
      do {
        let data = try Data(contentsOf: placesDataFileURL)
        let places = try JSONDecoder().decode([Place].self, from: data)

        debugPrint(places.count)

        let annotations = places.map { (p) -> MKPointAnnotation in
          let coordinate = CLLocationCoordinate2D(latitude: p.latitude, longitude: p.longitude)

          return MKPointAnnotation(__coordinate: coordinate,
                                   title: p.name, subtitle: p.description)
        }

        DispatchQueue.main.async {
          self.places = annotations
        }
      } catch {
        debugPrint(error)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    loadPlaces()
  }

}

struct MapKitMapView: UIViewControllerRepresentable {

  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }

  func makeUIViewController(context: UIViewControllerRepresentableContext<MapKitMapView>) -> MapKitMapViewController {

    let mkmpvc = MapKitMapViewController()
    mkmpvc.delegate = context.coordinator
    return mkmpvc
  }

  func updateUIViewController(_ uiViewController: MapKitMapViewController, context: UIViewControllerRepresentableContext<MapKitMapView>) {
    //
  }

  class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapKitMapView

    init(_ c: MapKitMapView) {
      parent = c

      super.init()
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
      debugPrint(mapView.region)
    }

  }
}
