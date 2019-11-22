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

  func updateUIViewController(_ uiViewController: MapViewController, context: UIViewControllerRepresentableContext<MapRepresentable>) {
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

//    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
//
//      return ClusterAnnotation(memberAnnotations: memberAnnotations)
//    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      var a: MKAnnotationView?

      if annotation is MKClusterAnnotation {
//        a = ClusterAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        a = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation)
      } else  {
        a = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
      }

      return a
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      guard let placeAnno = view.annotation as? UndetailedAnnotation else {
        return
      }

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

      parent.selected = true
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
      parent.selected = false
    }

  }

}
