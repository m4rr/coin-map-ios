//
//  MapKitMapViewController.swift
//  coin-map
//
//  Created by Marat Saytakov on 16.11.2019.
//  Copyright © 2019 saytakov. All rights reserved.
//

import SwiftUI
import MapKit

struct MapRepresentable: UIViewControllerRepresentable {

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

  func makeUIViewController(context: UIViewControllerRepresentableContext<MapRepresentable>) -> MapViewController {
    return MapViewController(coordinator: context.coordinator)
  }

  func updateUIViewController(_ uiViewController: MapViewController,
                              context: UIViewControllerRepresentableContext<MapRepresentable>) {
    //
  }

}

extension MapRepresentable {

  class Coordinator: NSObject, MKMapViewDelegate {

    var parent: MapRepresentable
    weak var controller: MapViewController?

    init(_ parent: MapRepresentable) {
      self.parent = parent

      super.init()
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
      //
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
      //
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      var aView: MKAnnotationView?

      if let anno = annotation as? MKClusterAnnotation {
        anno.title = nil
        anno.subtitle = nil

        aView = mapView.dequeueReusableAnnotationView(
          withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier,
          for: anno)

        aView?.displayPriority = .required
      } else {
        aView = mapView.dequeueReusableAnnotationView(
          withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
          for: annotation)

        aView?.displayPriority = .defaultLow
      }

      aView?.collisionMode = .rectangle

      return aView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      if let placeAnno = view.annotation as? UndetailedAnnotation {
        parent.title = placeAnno.title ?? ""
        parent.subtitle = placeAnno.hiddenSubtitle

        parent.phone = placeAnno.phone
        parent.website = placeAnno.website
        parent.hours = placeAnno.hours

        guard let c = controller else { return }
        parent.placeCurrencies = c.currenciesFor(placeID: placeAnno.placeID)

        parent.selected = true
      } else if let placeAnno = view.annotation as? MKClusterAnnotation {

        let st1 = placeAnno.memberAnnotations
          .compactMap({ $0.title ?? nil })
        let st2 = st1
          .reduce("", { $0 + "• " + $1 + "\n" })
          .trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch placeAnno.memberAnnotations.count {
        case 0 ... 10:
          parent.title = ""
          parent.subtitle = st2

        default:
          parent.title = placeAnno.memberAnnotations.count.description + " places"
          parent.subtitle = ""
        }

        parent.phone = ""
        parent.website = ""
        parent.hours = ""

        parent.placeCurrencies = []

        parent.selected = true
      }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
      parent.selected = false
    }

  }

}
