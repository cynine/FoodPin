//
//  WebViewController.swift
//  FoodPin
//
//  Created by Ray on 2021/10/10.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
  
  @IBOutlet var webView: WKWebView!
  
  var targetURL = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never
    // 导航栏定制
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.tintColor = .black
    navigationController?.hidesBarsOnSwipe = false
    
    if let url = URL(string: targetURL) {
      let request = URLRequest(url: url)
      webView.load(request)
    }
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // Get the new view controller using segue.destination.
       // Pass the selected object to the new view controller.
   }
   */
}
