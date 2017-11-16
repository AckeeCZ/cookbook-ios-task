//
//  RecipeTableViewCell.swift
//  Cookbook
//
//  Created by Admin on 13/11/2017.
//  Copyright © 2017 Dominik Vesely. All rights reserved.
//

import UIKit
import SnapKit

class RecipeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    weak var recipeImage: UIImageView!
    weak var recipeNameTextView: UITextView!
    weak var timerImage: UIImageView!
    weak var recipeTimeTextView: UITextView!

    let stars: [UIImageView] = {
        [UIImageView(image: #imageLiteral(resourceName: "ic_star")), UIImageView(image: #imageLiteral(resourceName: "ic_star")), UIImageView(image: #imageLiteral(resourceName: "ic_star")), UIImageView(image: #imageLiteral(resourceName: "ic_star")), UIImageView(image: #imageLiteral(resourceName: "ic_star"))]
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let recipeImage = UIImageView(image: #imageLiteral(resourceName: "img_small"))
        self.contentView.addSubview(recipeImage)
        self.recipeImage = recipeImage

        let recipeNameTextView = UITextView()
        self.contentView.addSubview(recipeNameTextView)
        self.recipeNameTextView = recipeNameTextView

        let timerImage = UIImageView(image: #imageLiteral(resourceName: "ic_time"))
        self.contentView.addSubview(timerImage)
        self.timerImage = timerImage

        let recipeTimeTextView = UITextView()
        self.contentView.addSubview(recipeTimeTextView)
        self.recipeTimeTextView = recipeTimeTextView

        updateTheme()
        setupCellUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func updateCell(with recipe: Recipe) {
        recipeNameTextView.text = recipe.name
        recipeTimeTextView.text = "\(recipe.duration) min."
        let ratingRounded = Int(floor(recipe.score))
        stars.enumerated().forEach { (index, imageView) in
            if index > ratingRounded {
                imageView.isHidden = true
            } else {
                return
            }
        }
    }

    func updateTheme() {
        recipeNameTextView.textColor = .blue
        recipeNameTextView.font = UIFont.boldSystemFont(ofSize: 22)
        recipeTimeTextView.font = UIFont.systemFont(ofSize: 14)
    }

    func setupCellUI() {
        recipeImage.contentMode = .scaleAspectFit
        recipeImage.snp.remakeConstraints { make in
            make.top.leading.equalTo(contentView).offset(8)
            make.width.height.equalTo(120)
        }
        recipeNameTextView.snp.remakeConstraints { make in
            make.trailing.equalTo(contentView).offset(8)
            make.top.equalTo(recipeImage)
            make.left.equalTo(recipeImage.snp.right).offset(8)
            make.height.equalTo(58)
        }
        let starsStackView = UIStackView(arrangedSubviews: stars)
        self.contentView.addSubview(starsStackView)
        for star in stars {
            star.contentMode = .scaleAspectFit
        }
        starsStackView.snp.remakeConstraints { make in
            make.left.equalTo(recipeImage.snp.right).offset(8)
            make.top.equalTo(recipeNameTextView.snp.bottom).offset(4)
            make.height.equalTo(25)
        }
        timerImage.snp.remakeConstraints { make in
            make.left.equalTo(recipeImage.snp.right).offset(14)
            make.bottom.equalTo(starsStackView).offset(24)
            make.height.width.equalTo(18)
        }
        recipeTimeTextView.snp.remakeConstraints { make in
            make.left.equalTo(timerImage.snp.right).offset(8)
            make.centerY.equalTo(timerImage).offset(-3)
            make.trailing.equalTo(contentView).offset(8)
            make.height.equalTo(25)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
