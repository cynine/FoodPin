//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Ray on 2021/10/5.
//

import UIKit
import CoreData
import UserNotifications

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  
  @IBOutlet var emptyRestaurantView: UIView!
  
  var restaurants: [RestaurantMO] = []
  var fetchResultController: NSFetchedResultsController<RestaurantMO>!
  
  var searchController: UISearchController!
  var searchResults: [RestaurantMO] = []
  
  //MARK: - 视图控制器生命周期
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnSwipe = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
      return
    }

    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
    if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
      present(walkthroughViewController, animated: true, completion: nil)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    tableView.cellLayoutMarginsFollowReadableWidth = true
    
    // 设置大标题
    navigationController?.navigationBar.prefersLargeTitles = true
    
    // 自订导航栏背景，让它透明化
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
      navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0), NSAttributedString.Key.font: customFont]
    }
    
    // 准备空视图
    tableView.backgroundView = emptyRestaurantView
    tableView.backgroundView?.isHidden = true
    
    // 从资料存储区中读取资料
    let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
      let context = appDelegate.persistentContainer.viewContext
      fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      fetchResultController.delegate = self
      
      do {
        try fetchResultController.performFetch()
        if let fetchedObjects = fetchResultController.fetchedObjects {
          restaurants = fetchedObjects
        }
      } catch {
        print(error)
      }
    }
    
    // 搜索栏初始化
    searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search restaurants..."
    searchController.searchBar.barTintColor = .white
    searchController.searchBar.backgroundImage = UIImage()
    searchController.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60)
    searchController.searchBar.searchBarStyle = .minimal
    tableView.tableHeaderView = searchController.searchBar
    
    // 检查是否支持3D Touch
    if (traitCollection.forceTouchCapability == .available) {
      registerForPreviewing(with: self as! UIViewControllerPreviewingDelegate, sourceView: view)
    }
    
    // Prepare for notifications
    prepareNotification()
  }
  
  // MARK: - NSFetchedResultsControllerDelegate
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      if let newIndexPath = newIndexPath {
        tableView.insertRows(at: [newIndexPath], with: .fade)
      }
    case .delete:
      if let indexPath = indexPath  {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
    case .update:
      if let indexPath = indexPath {
        tableView.reloadRows(at: [indexPath], with: .fade)
      }
    default:
      tableView.reloadData()
    }
    
    if let fetchedObjects = controller.fetchedObjects {
      restaurants = fetchedObjects as! [RestaurantMO]
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }

  // MARK: - UITableViewDataSource 协定

  override func numberOfSections(in tableView: UITableView) -> Int {
    if restaurants.count > 0 {
      tableView.backgroundView?.isHidden = true
      tableView.separatorStyle = .singleLine
    } else {
      tableView.backgroundView?.isHidden = false
      tableView.separatorStyle = .none
    }
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.isActive {
      return searchResults.count
    } else {
      return restaurants.count
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "datacell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestauranTableViewCell
    
    // 判断是从搜寻结果或是原来的序列来去餐厅
    let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
    
    // Cell设置
    cell.nameLabel.text = restaurant.name
    cell.locationLabel.text = restaurant.location
    cell.typeLable.text = restaurant.type
    if let restaurantImage = restaurant.image {
      cell.thumbnailImageView.image = UIImage(data: restaurantImage as Data)
    }
    cell.heartImageView.isHidden = restaurant.isVisited ? false : true

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
    
    checkAction.backgroundColor = UIColor(red: 38, green: 162, blue: 78)
    checkAction.image = UIImage(named: checkActionImage)
    
    let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkAction])
    
    return swipeConfiguration
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, sourceView, completionHandler) in
      // 从资料存储区删除一列
      if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        let context = appDelegate.persistentContainer.viewContext
        let restaurantToDelete = self.fetchResultController.object(at: indexPath)
        context.delete(restaurantToDelete)
        appDelegate.saveContext()
      }
      
      completionHandler(true)
    })
    
    let shareAction = UIContextualAction(style: .normal, title: "Share") { action, sourceView, completionHandler in
      let defaultText = "Just checking in at" + self.restaurants[indexPath.row].name!
      let activityController: UIActivityViewController
      if let restaurantImage = self.restaurants[indexPath.row].image, let imageToShare = UIImage(data: restaurantImage as Data) {
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
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if searchController.isActive {
      return false
    } else {
      return true
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showRestaurantDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let destinationController = segue.destination as! RestaurantDetailViewController
        destinationController.restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        destinationController.hidesBottomBarWhenPushed = true
      }
      searchController.dismiss(animated: true, completion: nil)
     }
  }
  
  @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - User Notifications
  
  func prepareNotification() {
      // Make sure the restaurant array is not empty
      if restaurants.count <= 0 {
          return
      }
      
      // Pick a restaurant randomly
      let randomNum = Int.random(in: 0..<restaurants.count)
      let suggestedRestaurant = restaurants[randomNum]
      
      // Get the image
      let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
      let tempFileURL = tempDirURL.appendingPathComponent("suggested-restaurant.jpg")
      
      // Create the user notification
      let content = UNMutableNotificationContent()
      
      content.title = "Restaurant Recommendation"
      content.subtitle = "Try new food today"
      content.body = "I recommend you to check out \(suggestedRestaurant.name!). The restaurant is one of your favorites. It is located at \(suggestedRestaurant.location!). Would you like to give it a try?"
      content.sound = UNNotificationSound.default
      
      if let image = UIImage(data: suggestedRestaurant.image! as Data) {
          
          try? image.jpegData(compressionQuality: 1.0)?.write(to: tempFileURL)
          if let restaurantImage = try? UNNotificationAttachment(identifier: "restaurantImage", url: tempFileURL, options: nil) {
              content.attachments = [restaurantImage]
          }
      }
      
      let categoryIdentifer = "foodpin.restaurantaction"
      let makeReservationAction = UNNotificationAction(identifier: "foodpin.makeReservation", title: "Reserve a table", options: [.foreground])
      let cancelAction = UNNotificationAction(identifier: "foodpin.cancel", title: "Later", options: [])
      let category = UNNotificationCategory(identifier: categoryIdentifer, actions: [makeReservationAction, cancelAction], intentIdentifiers: [], options: [])
      UNUserNotificationCenter.current().setNotificationCategories([category])
      content.categoryIdentifier = categoryIdentifer
      
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
      let request = UNNotificationRequest(identifier: "foodpin.restaurantSuggestion", content: content, trigger: trigger)
      
      // Schedule the notification
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
      
  }
  
}

// MARK: - UISearchResultsUpdating Delegate
extension RestaurantTableViewController: UISearchResultsUpdating {
  
  // MARK: - 过滤方法
  func filterContent(for searchText: String) {
    searchResults = restaurants.filter({
      (restaurant) -> Bool in
      if let name = restaurant.name, let location = restaurant.location {
        let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
        return isMatch
      }
      
      return false
    })
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text {
      filterContent(for: searchText)
      tableView.reloadData()
    }
  }
}


extension RestaurantTableViewController: UIViewControllerPreviewingDelegate {
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    guard let indexPath = tableView.indexPathForRow(at: location) else {
      return nil
    }
    
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return nil
    }
    
    guard let restaurantDetailViewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController else {
      return nil
    }
    
    
    let selectedRestaurant = self.restaurants[indexPath.row]
    
    restaurantDetailViewController.restaurant = selectedRestaurant
    
    restaurantDetailViewController.preferredContentSize = CGSize(width: 0.0, height: 460.0)
    previewingContext.sourceRect = cell.frame
    
    return restaurantDetailViewController
    
  }
  
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
    show(viewControllerToCommit, sender: self)
  }
}
