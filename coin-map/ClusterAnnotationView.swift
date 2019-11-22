import MapKit

class ClusterAnnotation: MKClusterAnnotation {

  override init(memberAnnotations: [MKAnnotation]) {
    super.init(memberAnnotations: memberAnnotations)

    title = nil
    subtitle = nil
  }

}

class ClusterAnnotationView: MKAnnotationView {

  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

    collisionMode = .circle
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
