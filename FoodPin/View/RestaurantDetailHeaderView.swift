//
//  RestaurantDetailHeaderView.swift
//  FoodPin
//
//  Created by leizhangjie on 2021/10/8.
//

import UIKit

class RestaurantDetailHeaderView: UIView {

  @IBOutlet var headertImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel! {
    didSet {
      nameLabel.numberOfLines = 0
    }
  }
  @IBOutlet var typeLable: UILabel! {
    didSet {
      typeLable.layer.cornerRadius = 5.0
      typeLable.layer.masksToBounds = true
    }
  }
  @IBOutlet var heartImageView: UIImageView! {
    didSet {
      heartImageView.image = UIImage(named: "heart-tick")?.withRenderingMode(.alwaysTemplate)
      heartImageView.tintColor = .white
    }
  }

}
