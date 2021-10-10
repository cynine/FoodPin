//
//  NewRestaurantController.swift
//  FoodPin
//
//  Created by Ray on 2021/10/9.
//

import UIKit
import CoreData
import CloudKit

class NewRestaurantController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet var photoImageView:UIImageView!
  
  @IBOutlet var nameTextField: RoundedTextField! {
    didSet {
      nameTextField.tag = 1
      nameTextField.becomeFirstResponder()
      nameTextField.delegate = self
    }
  }
  
  @IBOutlet var typeTextField: RoundedTextField! {
    didSet {
      typeTextField.tag = 2
      typeTextField.delegate = self
    }
  }
  
  @IBOutlet var addressTextField: RoundedTextField! {
    didSet {
      addressTextField.tag = 3
      addressTextField.delegate = self
    }
  }
  
  @IBOutlet var phoneTextField: RoundedTextField! {
    didSet {
      phoneTextField.tag = 4
      phoneTextField.delegate = self
    }
  }
  
  @IBOutlet var descriptionTextView: UITextView! {
    didSet {
      descriptionTextView.tag = 5
      descriptionTextView.layer.cornerRadius = 5.0
      descriptionTextView.layer.masksToBounds = true
    }
  }
  
  var restaurant: RestaurantMO!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 设置导航列外观
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.shadowImage = UIImage()
    
    if let customFont = UIFont(name: "Rubik-Medium", size: 35.0) {
      navigationController?.navigationBar.largeTitleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont]
    }
  }
  
  // MARK: - TextField deleagte
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let nextTextField = view.viewWithTag(textField.tag + 1) {
      textField.resignFirstResponder()
      nextTextField.becomeFirstResponder()
    }
    
    return true
  }
  
  func saveRecordToCloud(restaurant: RestaurantMO) -> Void {
    // 准备要存储的记录
    let record = CKRecord(recordType: "Restaurant")
    record.setValue(restaurant.name, forKey: "name")
    record.setValue(restaurant.type, forKey: "type")
    record.setValue(restaurant.location, forKey: "location")
    record.setValue(restaurant.phone, forKey: "phone")
    record.setValue(restaurant.summary, forKey: "description")
    
    let imageData = restaurant.image! as Data
    
    // 调整图片大小
    let originalImage = UIImage(data: imageData)!
    let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
    let scaledImage = UIImage(data: imageData, scale: scalingFactor)!
    
    // 将图片写进本地档案作为暂时使用
    let imageFilePath = NSTemporaryDirectory() + restaurant.name!
    let imageFileURL = URL(fileURLWithPath: imageFilePath)
    try? scaledImage.jpegData(compressionQuality: 0.8)?.write(to: imageFileURL)
    
    // 创建要上传的图片素材
    let imageAsset = CKAsset(fileURL: imageFileURL)
    record.setValue(imageAsset, forKey: "image")
    
    // 读取公告的iCloud资料库
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    // 储存资料至iCloud
    publicDatabase.save(record, completionHandler: { (record, error) -> Void in
      try? FileManager.default.removeItem(at: imageFileURL)
    })
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 6
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      let photoSourceRequestController = UIAlertController(title: "", message: "Chosse your photo source", preferredStyle: .actionSheet)
      
      let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
          let imagePicker = UIImagePickerController()
          imagePicker.allowsEditing = false
          imagePicker.sourceType = .camera
          imagePicker.delegate = self
          self.present(imagePicker, animated: true, completion: nil)
        }
      })
      
      let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
          let imagePicker = UIImagePickerController()
          imagePicker.allowsEditing = false
          imagePicker.sourceType = .photoLibrary
          imagePicker.delegate = self
          self.present(imagePicker, animated: true, completion: nil)
        }
      })
      
      photoSourceRequestController.addAction(cameraAction)
      photoSourceRequestController.addAction(photoLibraryAction)
      
      if let popoverController = photoSourceRequestController.popoverPresentationController {
        if let cell = tableView.cellForRow(at: indexPath) {
          popoverController.sourceView = cell
          popoverController.sourceRect = cell.bounds
        }
      }
      
      present(photoSourceRequestController, animated: true, completion: nil)
    }
  }
  
  // MARK: - UIImagePickerControllerDelegate
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      photoImageView.image = selectedImage
      photoImageView.contentMode = .scaleAspectFill
      photoImageView.clipsToBounds = true
    }
    
    let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
    leadingConstraint.isActive = true
    
    let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
    trailingConstraint.isActive = true
    
    let topConstranit = NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
    topConstranit.isActive = true
    
    let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
    bottomConstraint.isActive = true
    
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Action method
  @IBAction func saveButtonTapped(sender: AnyObject) {
    if nameTextField.text == "" || typeTextField.text == "" || addressTextField.text == "" || phoneTextField.text == "" || descriptionTextView.text == "" {
      let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
      
      return
    }
    
    print("Name: \(nameTextField.text ?? "")")
    print("Type: \(typeTextField.text ?? "")")
    print("Location: \(addressTextField.text ?? "")")
    print("Phone: \(phoneTextField.text ?? "")")
    print("Description: \(descriptionTextView.text ?? "")")
    
    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
      restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
      restaurant.name = nameTextField.text
      restaurant.type = typeTextField.text
      restaurant.location = addressTextField.text
      restaurant.phone = phoneTextField.text
      restaurant.summary = descriptionTextView.text
      restaurant.isVisited = false
      
      if let restaurantImage = photoImageView.image {
        restaurant.image = restaurantImage.pngData()
      }
      
      
      print("Save data to context...")
      appDelegate.saveContext()
    }
    
    saveRecordToCloud(restaurant: restaurant)
    dismiss(animated: true, completion: nil)
  }
}
