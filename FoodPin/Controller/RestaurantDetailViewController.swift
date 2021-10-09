//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Ray on 2021/10/7.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet var tableView: UITableView!
  @IBOutlet var headerView: RestaurantDetailHeaderView!

  var restaurant = Restaurant()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnSwipe = false
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never

    tableView.delegate = self
    tableView.dataSource = self

    // 设置标题视图
    headerView.nameLabel.text = restaurant.name
    headerView.typeLable.text = restaurant.type
    headerView.headertImageView.image = UIImage(named: restaurant.image)
    headerView.heartImageView.isHidden = restaurant.isVisited ? false : true

    tableView.separatorStyle = .none

    // 导航栏定制
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.tintColor = .white
    navigationController?.hidesBarsOnSwipe = false

    tableView.contentInsetAdjustmentBehavior = .never
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
    
    dismiss(animated: true, completion: {
      if let rating = segue.identifier {
        self.restaurant.rating = rating
        self.headerView.ratingImageView.image = UIImage(named: rating)
        
        let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        self.headerView.ratingImageView.transform = scaleTransform
        self.headerView.ratingImageView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
          self.headerView.ratingImageView.transform = .identity
          self.headerView.ratingImageView.alpha = 1
        }, completion: nil)
      }
    })
  }

  // MARK: - tableView DataSourc

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
      cell.iconImageView.image = UIImage(named: "phone")
      cell.shortTextLabel.text = restaurant.phone
      cell.selectionStyle = .none

      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
      cell.iconImageView.image = UIImage(named: "map")
      cell.shortTextLabel.text = restaurant.location
      cell.selectionStyle = .none

      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
      cell.descriptionLabel.text = restaurant.description
      cell.selectionStyle = .none

      return cell
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailSeparatorCell.self), for: indexPath) as! RestaurantDetailSeparatorCell
      cell.titleLabel.text = "HOW TO GET HERE"
      cell.selectionStyle = .none

      return cell
    case 4:
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
      cell.selectionStyle = .none
      cell.configure(location: restaurant.location)

      return cell
    default:
      fatalError("Failed to instantiate the table view cell for detail view controller")
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showMap" {
      let destinationController = segue.destination as! MapViewController
      destinationController.restaurant = restaurant
    } else if segue.identifier == "showReview" {
      let destinationController = segue.destination as! ReviewViewController
      destinationController.restaurant = restaurant
    }
  }
}
