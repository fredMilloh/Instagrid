//
//  GridView.swift
//  Instagrid
//
//  Created by fred on 19/08/2021.
//

import UIKit

class GridView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var gridViews: [UIView]!
    @IBOutlet private var gridImages: [UIImageView]!
    
    var buttonAction: (() -> Void)?
    private var currentTag = 0
    
    var styleLayout: StyleLayout = .layout1 {
        didSet {
            setStyleGrid(styleLayout)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    // After sharing a grid, new empty grid
    func emptyGrid() {
        guard let gridImages = gridImages else { return }
        gridImages.forEach { imageView in
            imageView.image = UIImage()
        }
    }
//A COMPLETER
    func gridIsNotComplete() -> Bool {
        var hiddenViews = [Bool]()
        var addedImage = [Bool]()
        
        gridViews.forEach { gridView in
            if !gridView.isHidden {
                hiddenViews.append(true)
            }
        }
        gridImages.forEach { imageView in
            let imageSize = imageView.image?.size
            if (imageSize != nil)  {
                addedImage.append(true)
            }
            print("addedImage + true ==> \(addedImage)")
        }
        let imageComplete = addedImage.allSatisfy({ $0 == true })
        print("image true ==> \(addedImage)")
        let viewShowned = hiddenViews.allSatisfy({ $0 == true })
        print("view showned true ==> \(hiddenViews)")
        return imageComplete && viewShowned
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
        }
    }
    
// MARK: - IBAction
    
    @IBAction func chooseImage(_ sender: UIButton) {
        buttonAction?()
        currentTag = sender.tag
    }
}

// MARK: - Public Methods

extension GridView {
    
    func set(image: UIImage) {
        gridImages[currentTag].image = image
        print("size selectedImage ==> \(String(describing: gridImages[currentTag].image?.size))")
        gridImages[currentTag].contentMode = .scaleAspectFill
    }
}

// MARK: - Convenience Methods

extension GridView {
    
    private func setStyleGrid(_ style: StyleLayout) {
        switch style {
        case .layout1:
            showGridButton()
            gridViews[1].isHidden = true
        case .layout2:
            showGridButton()
            gridViews[3].isHidden = true
        case .layout3:
            showGridButton()
        }
    }
    
    private func showGridButton() {
        gridViews.forEach { viewPicture in
            viewPicture.isHidden = false
        }
    }
            
    private func loadXib() {
        Bundle.main.loadNibNamed("GridView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
