//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by Ray on 2021/10/10.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
  var sectionTitles = ["Feedback", "Follow Us"]
  var sectionContent = [[(image: "store", text: "Rate us on App Store", link: "https://www.apple.com/itunes/charts/paid-apps/"),
                         (image: "chat", text: "Tell us your feedback", link: "http://www.appcoda.com/contact")],
                        [(image: "twitter", text: "Twitter", link: "https://twitter.com/appcodamobile"),
                         (image: "facebook", text: "Facebook", link: "https://facebook.com/appcodamobile"),
                         (image: "instagram", text: "Instagram", link: "https://www.instagram.com/appcodadotcom")]]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    
    tableView.cellLayoutMarginsFollowReadableWidth = true
    
    navigationController?.navigationBar.prefersLargeTitles = true
    
    // 设置导航栏外观
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
      navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont]
      
      tableView.tableFooterView = UIView()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showWebView" {
      if let destinationController = segue.destination as? WebViewController, let indexPath = tableView.indexPathForSelectedRow {
        destinationController.targetURL = sectionContent[indexPath.section][indexPath.row].link
      }
    }
  }
}

extension AboutTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitles.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sectionContent[section].count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath)
    
    // Configure the cell...
    let cellData = sectionContent[indexPath.section][indexPath.row]
    cell.textLabel?.text = cellData.text
    cell.imageView?.image = UIImage(named: cellData.image)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let link = sectionContent[indexPath.section][indexPath.row].link
    
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 {
        if let url = URL(string: link) {
          UIApplication.shared.open(url)
        }
      } else if indexPath.row == 1 {
        performSegue(withIdentifier: "showWebView", sender: self)
      }
    case 1:
      if let url = URL(string: link) {
        let safariController = SFSafariViewController(url: url)
        present(safariController, animated: true, completion: nil)
      }
    default:
      break
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
