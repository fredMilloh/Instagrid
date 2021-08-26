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
    @IBOutlet private var gridButtons: [UIButton]!
    
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
        buttonAction?()
        currentTag = sender.tag
    }
}

// MARK: - Public Methods

extension GridView {
    
    func set(image: UIImage) {
        gridButtons[currentTag].setBackgroundImage(image, for: .normal)
        gridButtons[currentTag].contentMode = .scaleToFill
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
    private func loadXib() {
        Bundle.main.loadNibNamed("GridView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
 
    }
}
