//
//  MapKitMapViewController.swift
//  coin-map
//
//  Created by Marat Saytakov on 16.11.2019.
//  Copyright © 2019 saytakov. All rights reserved.
//

import SwiftUI
import MapKit

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
    return MapKitMapViewController(coordinator: context.coordinator)
  }

  func updateUIViewController(_ uiViewController: MapKitMapViewController, context: UIViewControllerRepresentableContext<MapKitMapView>) {
    //
  }

  class Coordinator: NSObject, MKMapViewDelegate {

    var parent: MapKitMapView
    weak var controller: MapKitMapViewController?

    init(_ parent: MapKitMapView) {
      self.parent = parent

      super.init()
    }

//    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
//
//      return ClusterAnnotation(memberAnnotations: memberAnnotations)
//    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      if annotation is ClusterAnnotation {
        return ClusterAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
      } else if annotation is UndetailedPointAnnotation 
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      guard let placeAnno = view.annotation as? UndetailedPointAnnotation else {
        return
      }

//      placeAnno.iden

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
