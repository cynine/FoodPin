//
//  WalkthroughPageViewController.swift
//  FoodPin
//
//  Created by Ray on 2021/10/10.
//

import UIKit

protocol WalkthroughPageViewControllerDelegate: AnyObject {
  func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController {
  
  weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
  
  var pageHeadings = ["CREATE YOUR OWN FOOD GUIDE", "SHOW YOU THE LOCATION", "DISCOVER GREAT RESTAURANTS"]
  var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
  var pageSubHeadings = ["Pin your favorite restaurants and create your own food guide",
                          "Search and locate your favourite restaurant on Maps",
                          "Find restaurants shared by your friends and other foodies"]
  var currentIndex = 0
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // 将数据源设置为自己
    dataSource = self
    delegate = self
    
    // 创建第一个导航页面
    if let startingViewController = contentViewController(at: 0) {
      setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
    }
  }
  
  func forwardPage() {
    currentIndex += 1
    if let nextViewController = contentViewController(at: currentIndex) {
      setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
  }
}

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension WalkthroughPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  
  func contentViewController(at index: Int) -> WalkthroughContentViewController? {
    if index < 0 || index >= pageHeadings.count {
      return nil
    }
    
    // 创建新的视图并传递适合的资料
    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
    if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
      pageContentViewController.imageFile = pageImages[index]
      pageContentViewController.heading = pageHeadings[index]
      pageContentViewController.subHeading = pageSubHeadings[index]
      pageContentViewController.index = index
      
      return pageContentViewController
    }
    
    return nil
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    var index = (viewController as! WalkthroughContentViewController).index
    index -= 1
    
    return contentViewController(at: index)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    var index = (viewController as! WalkthroughContentViewController).index
    index += 1
    
    return contentViewController(at: index)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
        currentIndex = contentViewController.index
        
        walkthroughDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
      }
    }
  }
}
