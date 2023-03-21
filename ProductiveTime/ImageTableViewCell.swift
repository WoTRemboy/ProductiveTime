//
//  ImageTableViewCell.swift
//  ProductiveTime
//
//  Created by Roman Tverdokhleb on 20.03.2023.
//

import UIKit

class ImageTableViewCell: UITableViewCell, UITableViewDelegate {
    
    weak var delegate: ImageTableViewCellDelegate?

    static let identifier = "ImageCell"
    
    var alert = false
    var localIndex = 0
    
    public var imageValue: Data? = emptyImageEncoded
    
    let dateLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "March 6, 2024"
        label.textColor = textColorSet
        label.numberOfLines = 1
        
        label.font = .systemFont(ofSize: 18,
                                 weight: .light)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    let editImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = nil
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    let alertImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = nil
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    let imageReviewButton: UIButton = {
        
        let button = UIButton()
        
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 15
        
        button.setTitleColor(UIColor(red: 0,
                                     green: 0,
                                     blue: 0,
                                     alpha: 0.5),
                             for: .highlighted)
        
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true

        button.addTarget(self,
                         action: #selector(imageReviewButtonPressed),
                         for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func imageReviewButtonPressed(sender: UIButton) {
        
        delegate?.imageButtonTapped(in: self, imageValue: imageValue ?? emptyImageEncoded)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func dateLabelSetup() {
        
        guard let label = textLabel else { return }
        
        dateLabel.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: contentView.frame.width/20).isActive = true
        
        dateLabel.trailingAnchor.constraint(equalTo: editImageView.leadingAnchor, constant: -10).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func titleSetup() {
        
        guard let label = textLabel else { return }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: contentView.frame.width/20).isActive = true
        
        label.trailingAnchor.constraint(equalTo: editImageView.leadingAnchor, constant: -10).isActive = true
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true

    }
    
    
    private func editImageViewSetup() {
        
        editImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        editImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        editImageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        editImageView.widthAnchor.constraint(equalToConstant: 27).isActive = true
        
    }
    
    
    private func imageReviewButtonSetup() {
        
        imageReviewButton.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: contentView.frame.width/20).isActive = true
        
        imageReviewButton.trailingAnchor.constraint(equalTo: editImageView.leadingAnchor, constant: -10).isActive = true
        
        imageReviewButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        
        imageReviewButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        imageReviewButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateLabel.text = nil
        editImageView.image = nil
        imageReviewButton.imageView?.image = nil
    }
    
    func configure(with tableCell: [String : Any], index: Int) {
        
        let tc = TableViewCell()
        
        alert = tableCell["Alert"] as? Bool ?? false
        
        guard let label = textLabel else { return }
        
        localIndex = index

        label.text = tableCell["Name"] as? String
        label.numberOfLines = 3
        
        label.font = UIFont(name: tableCell["fontName"] as! String,
                            size: tableCell["fontSize"] as! CGFloat)
        
        if (tableCell["isCompleted"] as? Bool) == true {
            imageView!.image = tc.imageCheck
            label.textColor = .lightGray

        } else {
            imageView!.image = tc.imageUncheck
            label.textColor = textColorSet
        }
        
        if (tableCell["Alert"] as? Bool) == true {
            editImageView.image = tc.imageAlert
            
        } else {
            editImageView.image = tc.imageInfo
            
        }
        
        
        let timeStartFormatter = DateFormatter()
        timeStartFormatter.dateFormat = "MM.dd.yyyy HH:mm"
        
        let fromDate = timeStartFormatter.string(from: tableCell["Date"] as! Date)
        
        dateLabel.text = "Until: \(fromDate)"
        
        let decoded = try! PropertyListDecoder().decode(Data.self, from: tableCell["ImageValue"] as? Data ?? emptyImageEncoded )
        
        let image = UIImage(data: decoded)
        imageReviewButton.setImage(image, for: .normal)
        

        imageValue = tableCell["ImageValue"] as? Data ?? emptyImageEncoded
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.bounds.size = CGSize(width: 25, height: 25)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        contentView.addSubview(dateLabel)
        contentView.addSubview(editImageView)
        contentView.addSubview(imageReviewButton)
        
        titleSetup()
        dateLabelSetup()
        editImageViewSetup()
        imageReviewButtonSetup()
        
    }

}

protocol ImageTableViewCellDelegate: AnyObject {
    func imageButtonTapped(in cell: ImageTableViewCell, imageValue: Data)
}

