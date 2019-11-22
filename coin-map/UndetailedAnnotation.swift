//
//  UndetailedAnnotation.swift
//  coin-map
//
//  Created by Marat Saytakov on 21.11.2019.
//  Copyright © 2019 saytakov. All rights reserved.
//

import MapKit

class BubbleAnnotationView: MKMarkerAnnotationView {

  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

    clusteringIdentifier = "clustering"
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

class UndetailedAnnotation: NSObject, MKAnnotation {

  let title, subtitle: String?
  let coordinate: CLLocationCoordinate2D

  let phone, website, hours, placeID: String

  /// Wouldn't be shown on the map, but would be provided as data.
  let hiddenSubtitle: String

  init(_ coo: CLLocationCoordinate2D,
       title: String, subtitle: String,
       phone: String, website: String, hours: String,
       placeID: String) {

    self.hiddenSubtitle = subtitle

    self.phone = phone
    self.website = website
    self.hours = hours
    self.placeID = placeID

    self.title = title
    self.subtitle = nil
    self.coordinate = coo

    super.init()
  }

}
