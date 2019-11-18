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

  let phone, website, hours: String

  init(_ coo: CLLocationCoordinate2D,
       title: String, subtitle: String,
       phone: String, website: String, hours: String) {

    self.hiddenSubtitle = subtitle

    self.phone = phone
    self.website = website
    self.hours = hours

    super.init()

    self.title = title
    self.coordinate = coo
  }
}

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

    map?.delegate = delegate

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

        let annotations = places.compactMap { (p) -> UndetailedPointAnnotation? in
          guard p.visible else {
            return nil
          }

          let coordinate = CLLocationCoordinate2D(latitude: p.latitude, longitude: p.longitude)

          return UndetailedPointAnnotation(coordinate,
                                           title: p.name,
                                           subtitle: p.description,
                                           phone: p.phone,
                                           website: p.website,
                                           hours: p.openingHours)
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

  @Binding var selected: Bool
  @Binding var title: String
  @Binding var subtitle: String
  @Binding var phone: String
  @Binding var website: String
  @Binding var hours: String

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

    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      guard let a = view.annotation as? UndetailedPointAnnotation else {
        return
      }

      parent.selected = true
      parent.title = a.title ?? ""
      parent.subtitle = a.hiddenSubtitle

      parent.phone = a.phone
      parent.website = a.website
      parent.hours = a.hours
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
      parent.selected = false
    }

  }

}
