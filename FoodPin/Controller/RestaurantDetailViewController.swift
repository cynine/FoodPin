//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Ray on 2021/10/7.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
  
  @IBOutlet var restaurantImageView: UIImageView!
  
  @IBOutlet var restaurantNameLabel: UILabel!
  
  @IBOutlet var restaurantTypeLabel: UILabel!
  
  @IBOutlet var locationLabel: UILabel!
  
  var restaurant = Restaurant()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never

    restaurantImageView.image = UIImage(named: restaurant.image)
    restaurantNameLabel.text = restaurant.name
    restaurantTypeLabel.text = restaurant.type
    locationLabel.text = restaurant.location
  }
}
