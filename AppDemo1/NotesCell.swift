//
//  NotesCell.swift
//  AppDemo1
//
//  Created by 夜凛(丁志强) on 2024/7/4.
//

import Masonry
import SDWebImage
import SnapKit
import UIKit

class NotesCell: UICollectionViewCell {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(userAvatarImageView)
        contentView.addSubview(likesLabel)
        contentView.addSubview(likesImage)

        // 设置基本布局
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(240)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
        }
        userAvatarImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(10)
            make.size.equalTo(40)
        }
        likesImage.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.right.equalTo(likesLabel.snp.left).offset(-2)
            make.size.equalTo(16)
        }
        likesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likesImage.snp.centerY)
            make.right.equalToSuperview().inset(10)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        userAvatarImageView.contentMode = .scaleAspectFill
        userAvatarImageView.layer.cornerRadius = 20
        userAvatarImageView.clipsToBounds = true

        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .left

        likesLabel.font = UIFont.systemFont(ofSize: 10)
        likesLabel.textColor = .gray
        likesLabel.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    // var note: NotesModel?
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let userAvatarImageView = UIImageView()
    let likesLabel = UILabel()
    let likesImage = UIImageView()

    func configure(with note: NotesModel) {
       let imageUrl = "https://i.52112.com/icon/jpg/256/20190424/37588/1788146.jpg"
        imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
       
        if let userMessage = note.userMessage {
            userAvatarImageView.sd_setImage(with: URL(string: userMessage), completed: nil)
        }
        let likesUrl = "https://i.52112.com/icon/jpg/256/20201130/100653/4094731.jpg"
        likesImage.sd_setImage(with: URL(string: likesUrl), completed: nil)
        titleLabel.text = note.tittle
        likesLabel.text = "\(note.likes) likes"
    }
}
