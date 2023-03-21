//
//  ImagePreviewController.swift
//  ProductiveTime
//
//  Created by Roman Tverdokhleb on 20.03.2023.
//

import UIKit

class ImagePreviewController: UIViewController {
    
    public var imageToPreview: Data? = nil
        
    let imageView = UIImageView()
    
    
    public func configurate(imageValue: UIImage) {
        imageView.image = imageValue
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Preview"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(dismissSelf))
        
        imageView.frame = view.frame
        imageView.backgroundColor = .secondarySystemBackground
                
        let decoded = try! PropertyListDecoder().decode(Data.self, from: imageToPreview ?? emptyImageEncoded)
        
        let image = UIImage(data: decoded)
        imageView.image = image


        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

    }

}
