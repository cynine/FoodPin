//
//  RestauranTableViewCell.swift
//  FoodPin
//
//  Created by Ray on 2021/10/5.
//

import UIKit

class RestauranTableViewCell: UITableViewCell {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var locationLabel: UILabel!
  @IBOutlet var typeLable: UILabel!
  @IBOutlet var thumbnailImageView: UIImageView! {
    didSet {
      thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
      thumbnailImageView.clipsToBounds = true
    }
  }
  @IBOutlet var heartImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}
