//
//  PictureDetailController.swift
//  Instagrid
//
//  Created by fred on 09/08/2021.
//

import UIKit

class PictureDetailController: UIViewController {

    @IBOutlet weak var hello: UILabel?
    
    private var helloTitle: String!
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.helloTitle = title
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        view.backgroundColor = .white
        hello?.text = helloTitle
    }
}
