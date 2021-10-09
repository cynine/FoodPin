//
//  MapViewController.swift
//  FoodPin
//
//  Created by leizhangjie on 2021/10/9.
//

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {
  @IBOutlet var mapView: MKMapView!

  var restaurant = Restaurant()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    
    
    // 地图定制化
    mapView.showsCompass = true
    mapView.showsScale = true
    mapView.showsTraffic = true

    // 地址转换为座标后并标注在地图上
    let geoCoder = CLGeocoder()
    geoCoder.geocodeAddressString(restaurant.location, completionHandler: { placemarks, error in
      if let error = error {
        print(error)
        return
      }

      if let placemarks = placemarks {
        // 取得第一个地面坐标
        let placemark = placemarks[0]

        // 加上标注
        let annotation = MKPointAnnotation()
        annotation.title = self.restaurant.name
        annotation.subtitle = self.restaurant.type

        if let location = placemark.location {
          annotation.coordinate = location.coordinate

          // 显示标注
          self.mapView.showAnnotations([annotation], animated: true)
          self.mapView.selectAnnotation(annotation, animated: true)
        }
      }
    })
  }
  
  // MARK: - mapView delegate
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let identifier = "MyMarker"
    
    if annotation.isKind(of: MKUserLocation.self) {
      return nil
    }
    
    // 如果可行即将标注再重复使用
    var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
    
    if annotationView == nil {
      annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    }
    
    annotationView?.glyphText = "😋"
    annotationView?.markerTintColor = UIColor.orange
    
    return annotationView
  }
}
