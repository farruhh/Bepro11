//
//  PlaylistVideoCell.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/25.
//

import UIKit
class PlaylistVideoCell: UITableViewCell {
    static let id = "PlaylistVideoCell"
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Player_ic_slider_thumb")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = label.font.withSize(15)
        label.numberOfLines = 0
        return label
    }()
    let eventPeriodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = label.font.withSize(15)
        label.numberOfLines = 0
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = ""
        label.font = label.font.withSize(15)
        label.numberOfLines = 0
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCell(_ matchVideos: MatchVideo) {
        if let title = matchVideos.video?.title {
           let startIndex = title.index(title.startIndex, offsetBy: 20)
            let endIndex = title.index(title.startIndex, offsetBy: 30)
            let range = startIndex...endIndex
            let videoTitle = String(title[range])
            self.titleLabel.text = videoTitle
        }
        self.eventPeriodLabel.text = matchVideos.eventPeriod
        self.dateLabel.text  = matchVideos.created
    }

    private func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(eventPeriodLabel)
        addSubview(titleLabel)
        addSubview(dateLabel)
        self.thumbnailImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
        self.dateLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
            make.right.equalTo(self.snp.right).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(15)
        }
        self.eventPeriodLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(thumbnailImageView.snp.right).offset(10)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(titleLabel.snp.top)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(thumbnailImageView.snp.right).offset(10)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
