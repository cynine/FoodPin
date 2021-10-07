//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Ray on 2021/10/5.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
  
  var restaurants:[Restaurant] = [
      Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "Hong Kong", image: "cafedeadend", isVisited: false),
      Restaurant(name: "Homei", type: "Cafe", location: "Hong Kong", image: "Homei", isVisited: false),
      Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "Teakha", isVisited: false),
      Restaurant(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Hong Kong", image: "cafeloisl", isVisited: false),
      Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong", image: "petiteoyster", isVisited: false),
      Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "forkeerestaurant", isVisited: false),
      Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong", image: "posatelier", isVisited: false),
      Restaurant(name: "Bourke Street Backery", type: "Chocolate", location: "Sydney", image: "bourkestreetbakery", isVisited: false),
      Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney", image: "haighschocolate", isVisited: false),
      Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Sydney", image: "palominoespresso", isVisited: false),
      Restaurant(name: "Upstate", type: "American", location: "New York", image: "Upstate", isVisited: false),
      Restaurant(name: "Traif", type: "American", location: "New York", image: "Traif", isVisited: false),
      Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "New York", image: "grahamavenuemeats", isVisited: false),
      Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "New York", image: "wafflewolf", isVisited: false),
      Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "fiveleaves", isVisited: false),
      Restaurant(name: "Cafe Lore", type: "Latin American", location: "New York", image: "cafelore", isVisited: false),
      Restaurant(name: "Confessional", type: "Spanish", location: "New York", image: "Confessional", isVisited: false),
      Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "Barrafina", isVisited: false),
      Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "Donostia", isVisited: false),
      Restaurant(name: "Royal Oak", type: "British", location: "London", image: "royaloak", isVisited: false),
      Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "London", image: "caskpubkitchen", isVisited: false)
  ]
  
  //MARK: - 视图控制器生命周期
  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    tableView.cellLayoutMarginsFollowReadableWidth = true
    
    // 设置大标题
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  // MARK: - UITableViewDataSource 协定

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return restaurants.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "datacell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestauranTableViewCell
    
    // Cell设置
    cell.nameLabel.text = restaurants[indexPath.row].name
    cell.locationLabel.text = restaurants[indexPath.row].location
    cell.typeLable.text = restaurants[indexPath.row].type
    cell.thumbnailImageView.image = UIImage(named: restaurants[indexPath.row].image)
    
    cell.heartImageView.isHidden = !restaurants[indexPath.row].isVisited

    return cell
  }
  
//  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    // 反序列
//    tableView.deselectRow(at: indexPath, animated: false)
//    // 创建一个类似动作清单的选单
//    let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
//
//    let callActionHandler = { (action: UIAlertAction!) -> Void in
//      let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .alert)
//      alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//      self.present(alertMessage, animated: true, completion: nil)
//    }
//
//    let callAction = UIAlertAction(title: "Call" + "123-000-\(indexPath.row)", style: .default, handler: callActionHandler)
//    optionMenu.addAction(callAction)
//
//    if let popoverController = optionMenu.popoverPresentationController {
//      if let cell = tableView.cellForRow(at: indexPath) {
//          popoverController.sourceView = cell
//          popoverController.sourceRect = cell.bounds
//      }
//    }
//
//    // 加入动作至选单中
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: callActionHandler)
//    optionMenu.addAction(cancelAction)
//
//    let checkInActionTilte = self.restaurantIsVisited[indexPath.row] ? "Undo Check-in" : "Check in"
//
//    let checkInAction = UIAlertAction(title: checkInActionTilte, style: .default, handler: {
//      (action: UIAlertAction!) -> Void in
//      self.restaurantIsVisited[indexPath.row] = !self.restaurantIsVisited[indexPath.row]
//      self.tableView.reloadData()
//    })
//
//    optionMenu.addAction(checkInAction)
//
//    // 呈现选单
//    present(optionMenu, animated: true, completion: nil)
//  }
  
  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let checkActionTitle = self.restaurants[indexPath.row].isVisited ? "Undo Check-in": "Check in"
    let checkActionImage = self.restaurants[indexPath.row].isVisited ? "undo": "tick"
    let checkAction = UIContextualAction(style: .normal, title: checkActionTitle, handler: { (action, sourceView, completionHandler) in
      self.restaurants[indexPath.row].isVisited = !self.restaurants[indexPath.row].isVisited
      self.tableView.reloadRows(at: [indexPath], with: .fade)
      completionHandler(true)
    })
    
    checkAction.backgroundColor = UIColor.systemGreen
    checkAction.image = UIImage(named: checkActionImage)
    
    let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkAction])
    
    return swipeConfiguration
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, sourceView, completionHandler) in
      self.restaurants.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .fade)
      
      completionHandler(true)
    })
    
    let shareAction = UIContextualAction(style: .normal, title: "Share") { action, sourceView, completionHandler in
      let defaultText = "Just checking in at" + self.restaurants[indexPath.row].name
      let activityController: UIActivityViewController
      if let imageToShare = UIImage(named: self.restaurants[indexPath.row].image) {
        activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
      } else {
        activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
      }
      if let popoverController = activityController.popoverPresentationController {
        if let cell = tableView.cellForRow(at: indexPath) {
          popoverController.sourceView = cell
          popoverController.sourceRect = cell.bounds
        }
      }
      self.present(activityController, animated: true, completion: nil)
      completionHandler(true)
    }
    
    deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    
    shareAction.backgroundColor = UIColor(red: 254.0/255.0, green: 149.0/255.0, blue: 38.0/255.0, alpha: 1.0)
    
    shareAction.image = UIImage(named: "share")
    deleteAction.image = UIImage(named: "delete")
    
    let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    
    return swipeConfiguration
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showRestaurantDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let destinationController = segue.destination as! RestaurantDetailViewController
        destinationController.restaurant = restaurants[indexPath.row]
      }
     }
  }
}
