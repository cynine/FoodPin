//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by leizhangjie on 2021/10/9.
//

import UIKit

class ReviewViewController: UIViewController {
  
  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var rateButtons: [UIButton]!
  @IBOutlet var closeButton: UIButton!
  
  var restaurant: RestaurantMO!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    if let restaurantImage = restaurant.image {
      backgroundImageView.image = UIImage(data: restaurantImage as Data)
    }
    
    // Applying the blur effect
    let blurEffect = UIBlurEffect(style: .dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    backgroundImageView.addSubview(blurEffectView)
    
    // 让按钮隐藏
    for rateButton in rateButtons {
      rateButton.alpha = 0
    }
    
    let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
    let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
    let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
    
    // 让按钮隐藏
    for rateButton in rateButtons {
      rateButton.transform = moveScaleTransform
      rateButton.alpha = 0
    }
    
    // Move up the closee button
    let moveUpTransform = CGAffineTransform.init(translationX: 0, y: -400)
    closeButton.transform = moveUpTransform
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    UIView.animate(withDuration: 2.0) {
//      self.rateButtons[0].alpha = 1.0
//      self.rateButtons[1].alpha = 1.0
//      self.rateButtons[2].alpha = 1.0
//      self.rateButtons[3].alpha = 1.0
//      self.rateButtons[4].alpha = 1.0
//    }
//    UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
//      self.rateButtons[0].alpha = 1.0
//      self.rateButtons[0].transform = .identity
//    }, completion: nil)
//
//    UIView.animate(withDuration: 0.4, delay: 0.15, options: [], animations: {
//      self.rateButtons[1].alpha = 1.0
//      self.rateButtons[1].transform = .identity
//    }, completion: nil)
//
//    UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
//      self.rateButtons[2].alpha = 1.0
//      self.rateButtons[2].transform = .identity
//    }, completion: nil)
//
//    UIView.animate(withDuration: 0.4, delay: 0.25, options: [], animations: {
//      self.rateButtons[3].alpha = 1.0
//      self.rateButtons[3].transform = .identity
//    }, completion: nil)
//
//    UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
//      self.rateButtons[4].alpha = 1.0
//      self.rateButtons[4].transform = .identity
//    }, completion: nil)
    
    for index in 0...4 {
      UIView.animate(withDuration: 0.4, delay: (0.1 + 0.05 * Double(index)), options: [], animations: {
        self.rateButtons[index].alpha = 1.0
        self.rateButtons[index].transform = .identity
      }, completion: nil)
    }
    
    UIView.animate(withDuration: 0.4) {
        self.closeButton.transform = .identity
    }
  }
  
  @IBAction func close(segue: UIStoryboardSegue) {
    dismiss(animated: true, completion: nil)
  }
}
