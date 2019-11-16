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

  override func loadView() {
    let map = MKMapView()

    view = map
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
