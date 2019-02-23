//
//  StoryCell.swift
//  Wattpad_Test
//
//  Created by Rupika Sompalli on 22/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {
    
    @IBOutlet weak var storyIconView : UIImageView!
    @IBOutlet weak var storyNameLabel : UILabel!
    @IBOutlet weak var userLabel : UILabel!
    @IBOutlet weak var storyTypeLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configure(_ story : Story?){
        if let story = story{
            storyNameLabel.text = story.title
            if let img = story.coverImg{
                storyIconView.image = img
            }else{
                //show placeholder icon
                storyIconView.image = UIImage(named: "wattpad_icon")
            }
            userLabel.text = story.user?.name
        }else{
            storyNameLabel.text = ""
            storyIconView.image = UIImage(named: "wattpad_icon")
            userLabel.text = ""
        }
       
    }
    
    
    
}

extension UIImage {
    
    func scaled(with scale: CGFloat) -> UIImage? {
        // size has to be integer, otherwise it could get white lines
        let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
   }
}
