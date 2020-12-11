//
//  CustomImageView.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/10.
//

import UIKit

import Then
import SnapKit
import Kingfisher

class CustomImageView: UIView {
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isHidden = true
        $0.backgroundColor = .lightGray
    }
    
    let aaaView = UIView().then {
        $0.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
    }
    
    let dateTimeLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.isHidden = true
    }
    
    let siteNameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.isHidden = true
    }
    
    
    fileprivate func configureUI() {
        
        [imageView, aaaView,
         dateTimeLabel, siteNameLabel].forEach {
            self.addSubview($0)
         }
        
        [dateTimeLabel].forEach {
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        aaaView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dateTimeLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        }
        
        siteNameLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.lessThanOrEqualTo(dateTimeLabel.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-16)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setURL(urlName: String, dateTime: String, siteName: String) {
        [self.imageView, self.dateTimeLabel, self.siteNameLabel].forEach {
            $0.isHidden = false
        }
        
        self.imageView.kf.setImage(with: URL(string: urlName), options: [.cacheMemoryOnly,
                                                                         .transition(.fade(0.2))])
        self.dateTimeLabel.text = dateTime
        self.siteNameLabel.text = siteName
        
        self.setNeedsLayout()
    }
}
