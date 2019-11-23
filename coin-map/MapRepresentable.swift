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

      if let _ = annotation as? MKClusterAnnotation,
        let clusterView = mapView.dequeueReusableAnnotationView(
          withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier,
          for: annotation) as? MKMarkerAnnotationView {

        // cluster

        clusterView.markerTintColor = .systemBlue
        clusterView.displayPriority = .required

        clusterView.titleVisibility = .hidden
        clusterView.subtitleVisibility = .hidden

        clusterView.collisionMode = .rectangle
        clusterView.clusteringIdentifier = nil

        return clusterView

      } else if let markerView = mapView.dequeueReusableAnnotationView(
          withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
          for: annotation) as? MKMarkerAnnotationView {

        // not a cluster

        markerView.glyphText = (annotation.title ?? nil)?.first.flatMap(String.init)
        markerView.displayPriority = .defaultLow
        markerView.markerTintColor = nil

        markerView.titleVisibility = .visible
        markerView.subtitleVisibility = .hidden

        markerView.collisionMode = .rectangle
        markerView.clusteringIdentifier = "clustering"

        return markerView
      }

      return nil
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

      if let placeAnno = view.annotation as? DetailedAnnotation {

        parent.title = placeAnno.title ?? ""
        parent.subtitle = placeAnno.hiddenSubtitle

        parent.phone = placeAnno.phone
        parent.website = placeAnno.website
        parent.hours = placeAnno.hours

        guard let c = controller else { return }
        parent.placeCurrencies = c.currenciesFor(placeID: placeAnno.placeID)

        parent.selected = true

      } else if let placeAnno = view.annotation as? MKClusterAnnotation {

        parent.title = placeAnno.memberAnnotations.count.description + " places"

        switch placeAnno.memberAnnotations.count {
        case 0 ... 10:
          let st1 = placeAnno.memberAnnotations
            .compactMap({ $0.title ?? nil })
            .map({ "• " + $0 })

          let st2 = st1
            .joined(separator: "\n")

          parent.subtitle = st2

        case 11 ... 20:
          let st1 = placeAnno.memberAnnotations
            .compactMap({ $0.title ?? nil })
            .joined(separator: " • ")

          parent.subtitle = st1

        default:
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
