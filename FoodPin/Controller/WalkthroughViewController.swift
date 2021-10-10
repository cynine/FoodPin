//
//  WalkthroughViewController.swift
//  FoodPin
//
//  Created by Ray on 2021/10/10.
//

import UIKit

class WalkthroughViewController: UIViewController {
  @IBOutlet var pageControl: UIPageControl!
  @IBOutlet var nextButton: UIButton! {
    didSet {
      nextButton.layer.cornerRadius = 25.0
      nextButton.layer.masksToBounds = true
    }
  }

  @IBOutlet var skipButton: UIButton!

  var walkthroughtPageViewController: WalkthroughPageViewController?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  @IBAction func skipButtonTapped(sender: UIButton) {
    UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
    createQuickActions()
    dismiss(animated: true, completion: nil)
  }

  @IBAction func nextButtonTapped(sender: UIButton) {
    if let index = walkthroughtPageViewController?.currentIndex {
      switch index {
      case 0 ... 1:
        walkthroughtPageViewController?.forwardPage()
      case 2:
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        createQuickActions()
        dismiss(animated: true, completion: nil)
      default:
        break
      }
    }

    updateUI()
  }

  // MARK: - 3D Touch

  func createQuickActions() {
    // Add Quick Actions
    if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
      if let bundleIdentifier = Bundle.main.bundleIdentifier {
        let shortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenFavorites", localizedTitle: "Show Favorites", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "favorite"), userInfo: nil)
        let shortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenDiscover", localizedTitle: "Discover Restaurants", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "discover"), userInfo: nil)
        let shortcutItem3 = UIApplicationShortcutItem(type: "\(bundleIdentifier).NewRestaurant", localizedTitle: "New Restaurant", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .add), userInfo: nil)
        UIApplication.shared.shortcutItems = [shortcutItem1, shortcutItem2, shortcutItem3]
      }
    }
  }

  func updateUI() {
    if let index = walkthroughtPageViewController?.currentIndex {
      switch index {
      case 0 ... 1:
        nextButton.setTitle("NEXT", for: .normal)
        skipButton.isHidden = false
      case 2:
        nextButton.setTitle("GET STARTED", for: .normal)
        skipButton.isHidden = true
      default:
        break
      }

      pageControl.currentPage = index
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destination = segue.destination
    if let pageViewController = destination as? WalkthroughPageViewController {
      walkthroughtPageViewController = pageViewController
      walkthroughtPageViewController?.walkthroughDelegate = self
    }
  }
}

extension WalkthroughViewController: WalkthroughPageViewControllerDelegate {
  func didUpdatePageIndex(currentIndex: Int) {
    updateUI()
  }
}
