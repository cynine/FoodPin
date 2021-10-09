//
//  RestaurantDetailMapCell.swift
//  FoodPin
//
//  Created by leizhangjie on 2021/10/9.
//

import MapKit
import UIKit

class RestaurantDetailMapCell: UITableViewCell {
  @IBOutlet var mapView: MKMapView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    // 初始化程序码
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
    // 设置视图为选中状态
  }

  func configure(location: String) {
    // 取得位置
    let geoCoder = CLGeocoder()

    print(location)
    geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }

      if let placemarks = placemarks {
        // 取得第一个地理坐标
        let placemark = placemarks[0]

        // 加上标注
        let annotation = MKPointAnnotation()

        if let location = placemark.location {
          // 显示标注
          annotation.coordinate = location.coordinate
          self.mapView.addAnnotation(annotation)

          // 设定缩放程度
          let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
          self.mapView.setRegion(region, animated: false)
        }
      }
    })
  }
}
