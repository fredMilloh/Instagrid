//
//  GridView.swift
//  Instagrid
//
//  Created by fred on 19/08/2021.
//

import UIKit

class GridView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet private var gridViews: [UIView]!
    @IBOutlet private var gridButtons: [UIButton]!
    
    var currentButton: (() -> Void)? = nil
    private var currentTag = 0
    var styleLayout: StyleLayout = .layout1 {
        didSet {
            setStyleGrid(styleLayout)
        }
    }
    var currentImage: UIImage = UIImage() {
        didSet {
            gridButtons[currentTag].setBackgroundImage(currentImage, for: .normal)
            //gridButtons[currentTag].contentMode = .center
            gridButtons[currentTag].contentMode = .scaleAspectFit
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // After sharing a grid, new empty grid
    func emptyGrid() {
        guard let gridButtons = gridButtons else { return }
        gridButtons.forEach { button in
            button.setBackgroundImage(nil, for: .normal)
        }
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
        }
    }
    
// MARK: - IBAction
    
    @IBAction func chooseImage(_ sender: UIButton) {
        if let currentButton = self.currentButton {
            currentButton()
        }
        currentTag = sender.tag
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
    
    // Load Xib GridView
    private func commonInit() {
        Bundle.main.loadNibNamed("GridView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
 
    }
}
