//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Ray on 2021/10/10.
//

import CloudKit
import UIKit

class DiscoverTableViewController: UITableViewController {
  var restaurants: [CKRecord] = []

  var spinner = UIActivityIndicatorView()

  private var imageCache = NSCache<CKRecord.ID, NSURL>()

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.cellLayoutMarginsFollowReadableWidth = true

    navigationController?.navigationBar.prefersLargeTitles = true

    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
      navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont]
    }

    fetchRecordsFromCloud()

    spinner.style = .gray
    spinner.hidesWhenStopped = true
    view.addSubview(spinner)

    // 定义旋转指示器的布局约束条件
    spinner.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
      spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])

    // 启用旋转指示器
    spinner.startAnimating()
    
    // 下拉更新控制
    refreshControl = UIRefreshControl()
    refreshControl?.backgroundColor = UIColor.white
    refreshControl?.tintColor = UIColor.gray
    refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: .valueChanged)
  }

  @objc func fetchRecordsFromCloud() {
    // 在更新之前移除目前的数据
    restaurants.removeAll()
    tableView.reloadData()
    
    // 使用 Convenience API取得资料
    let cloudContainer = CKContainer.default()
    let publicDatabase = cloudContainer.publicCloudDatabase
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Restaurant", predicate: predicate)
//    query.sortDescriptors = [NSSortDescriptor(key: "createdTimestamp", ascending: false)]

    // 以query创建查询操作
    let queryOperation = CKQueryOperation(query: query)
    queryOperation.desiredKeys = ["name", "type", "phone", "location", "description"]
    queryOperation.queuePriority = .veryHigh
    queryOperation.resultsLimit = 50
    queryOperation.recordFetchedBlock = { (record) -> Void in
      self.restaurants.append(record)
    }

    queryOperation.queryCompletionBlock = { [unowned self] (_, error) -> Void in
      
      if let error = error {
        print("Failed to get data from iCloud - \(error.localizedDescription)")
        return
      }

      print("Successfully retrieve the data from iCloud")
      DispatchQueue.main.async {
        self.spinner.stopAnimating()
        self.tableView.reloadData()
        
        if let refreshControl = self.refreshControl {
          if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
          }
        }
      }
         
    }

    // 执行查询
    publicDatabase.add(queryOperation)

//    publicDatabase.perform(query, inZoneWith: nil, completionHandler: { (results, error) -> Void in
//      if let error = error {
//        print(error)
//        return
//      }
//
//      if let results = results {
//        print("Completed the download of Restaurant data")
//        self.restaurants = results
//        DispatchQueue.main.async {
//          self.tableView.reloadData()
//        }
//      }
//    })
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return restaurants.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath) as! DiscoverTableViewCell

    let restaurant = restaurants[indexPath.row]
    cell.nameLabel.text = restaurant.object(forKey: "name") as? String
    cell.typeLabel.text = restaurant.object(forKey: "type") as? String
    cell.phoneLabel.text = restaurant.object(forKey: "phone") as? String
    cell.locationLabel.text = restaurant.object(forKey: "location") as? String
    cell.descriptionLabel.text = restaurant.object(forKey: "description") as? String
    
    // Set the default image
    cell.featuredImageView.image = UIImage(named: "photo")
    
    // 检查图片是否已经在高速缓存中
    if let imageFileURL = imageCache.object(forKey: restaurant.recordID) {
      // 从高速缓存中取得图片
      print("Get image from cache")
      if let imageData = try? Data(contentsOf: imageFileURL as URL) {
        cell.featuredImageView.image = UIImage(data: imageData)
      }
    } else {
      // 在后台从云端取得图片
      let publicDatabase = CKContainer.default().publicCloudDatabase
      let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
      fetchRecordsImageOperation.desiredKeys = ["image"]
      fetchRecordsImageOperation.queuePriority = .veryHigh

      fetchRecordsImageOperation.perRecordCompletionBlock = { [unowned self] (record, _, error) -> Void in
        if let error = error {
          print("Failed to get restaurant image: \(error.localizedDescription)")
          return
        }

        if let restaurantRecord = record, let image = restaurantRecord.object(forKey: "image"), let imageAsset = image as? CKAsset {
          if let imageData = try? Data(contentsOf: imageAsset.fileURL ?? URL(string: "")!) {
            DispatchQueue.main.async {
              cell.featuredImageView.image = UIImage(data: imageData)
              cell.setNeedsLayout()
            }
            
            self.imageCache.setObject(imageAsset.fileURL as! NSURL, forKey: restaurant.recordID)
          }
        }
      }

      publicDatabase.add(fetchRecordsImageOperation)
    }

    return cell
  }

  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       // Return false if you do not want the specified item to be editable.
       return true
   }
   */

  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           // Delete the row from the data source
           tableView.deleteRows(at: [indexPath], with: .fade)
       } else if editingStyle == .insert {
           // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
       }
   }
   */

  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

   }
   */

  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
       // Return false if you do not want the item to be re-orderable.
       return true
   }
   */

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // Get the new view controller using segue.destination.
       // Pass the selected object to the new view controller.
   }
   */
}
