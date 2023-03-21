//
//  TableViewCell.swift
//  ProductiveTime
//
//  Created by Roman Tverdokhleb on 18.03.2023.
//

import UIKit

class TableViewCell: UITableViewCell, UITableViewDelegate {

    static let identifier = "NoImageCell"
    var alert = false
    
    public let imageInfo = UIImage(
        systemName: "info.circle",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.systemBlue, .systemBlue]))
    
    public let imageAlert = UIImage(
        systemName: "exclamationmark.circle",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.systemRed, .systemRed]))
    
    public let imageCheck = UIImage(
        systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.white, .systemGreen]))
    
    public let imageUncheck = UIImage(
        systemName: "circle",
        withConfiguration: UIImage.SymbolConfiguration(
            weight: .ultraLight))?
        .withTintColor(.gray, renderingMode: .alwaysOriginal)
    
    let dateLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "March 6, 2024"
        label.textColor = textColorSet
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .light)
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
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func dateLabelSetup() {
        
        guard let label = textLabel else { return }
        
        dateLabel.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: contentView.frame.width/19).isActive = true
        
        dateLabel.trailingAnchor.constraint(equalTo: editImageView.leadingAnchor, constant: -10).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    private func titleSetup() {
        
        guard let label = textLabel else { return }
                
        label.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: contentView.frame.width/20).isActive = true
        
        label.trailingAnchor.constraint(equalTo: editImageView.leadingAnchor, constant: -10).isActive = true
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func imageViewSetup() {
        
        imageView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.frame.width/20).isActive = true
        
        imageView?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        imageView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        imageView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        imageView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func editImageViewSetup() {
        
        editImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        editImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        editImageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        editImageView.widthAnchor.constraint(equalToConstant: 27).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateLabel.text = nil
        editImageView.image = nil
    }
    
    func configure(with tableCell: [String : Any], index: Int) {
        
        alert = tableCell["Alert"] as? Bool ?? false
        
        guard let label = textLabel else { return }

        label.text = tableCell["Name"] as? String
        label.numberOfLines = 3
        
        label.font = UIFont(name: tableCell["fontName"] as! String,
                            size: tableCell["fontSize"] as! CGFloat)
        
        if (tableCell["isCompleted"] as? Bool) == true {
            imageView!.image = imageCheck
            label.textColor = .lightGray

        } else {
            imageView!.image = imageUncheck
            label.textColor = textColorSet
        }
        
        if (tableCell["Alert"] as? Bool) == true {
            editImageView.image = imageAlert
            
        } else {
            editImageView.image = imageInfo
            
        }
        
        let timeStartFormatter = DateFormatter()
        timeStartFormatter.dateFormat = "MM.dd.yyyy HH:mm"
        
        let fromDate = timeStartFormatter.string(from: tableCell["Date"] as! Date)
        
        dateLabel.text = "Until: \(fromDate)"

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.bounds.size = CGSize(width: 25, height: 25)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        contentView.addSubview(dateLabel)
        contentView.addSubview(editImageView)
        
        titleSetup()
        editImageViewSetup()
        dateLabelSetup()
    }

}
