//
//  ViewController.swift
//  Instagrid
//
//  Created by fred on 02/08/2021.
//

import UIKit

class GridViewController: UIViewController {
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet var layoutButtonSelectedMark: [UIImageView]!
    
    let imagePicker = UIImagePickerController()
    var gridIsEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpGridView()
    }
    
    // MARK: - IBActions
    
    @IBAction func switchLayout(_ sender: UIButton) {
        guard let layout = StyleLayout.init(rawValue: sender.tag) else { return }
        gridView.styleLayout = layout
        setUpButtons(with: layout)
    }
    
    @IBAction func swipeGrid(_ sender: UISwipeGestureRecognizer) {
        let orientationDevice = UIDevice.current.orientation
        let direction = sender.direction
        
        if orientationDevice.isPortrait && direction == .up {
            gridIsEmpty ? showAlertEmptyGrid(with: .up) : swipe(by: .up)
        }
        if orientationDevice.isLandscape && direction == .left {
            gridIsEmpty ? showAlertEmptyGrid(with: .left) : swipe(by: .left)
        }
    }
}

// MARK: - Layout

extension GridViewController {
    
    private func setUpGridView() {
        gridView.transform = .identity
        gridView.emptyGrid()
        gridView.styleLayout = .layout2
        setUpButtons(with: .layout2)
        
        gridView.buttonAction = {
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            DispatchQueue.main.async {
                self.present(self.imagePicker, animated: true)
            }
        }
    }
    
    private func setUpButtons(with style: StyleLayout) {
        switch style {
        case .layout1:
            hideLayoutSelectedImage()
            layoutButtonSelectedMark[0].isHidden = false
        case .layout2:
            hideLayoutSelectedImage()
            layoutButtonSelectedMark[1].isHidden = false
        case .layout3:
            hideLayoutSelectedImage()
            layoutButtonSelectedMark[2].isHidden = false
        }
    }
    
    private func hideLayoutSelectedImage() {
        layoutButtonSelectedMark.forEach { selectedImage in
            selectedImage.isHidden = true
        }
    }
}

// MARK: - UIImagePicker

extension GridViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            gridView.set(image: selectedImage)
            gridIsEmpty = false
        }
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Swipe Grid

extension GridViewController {
   
    private func swipe(by direction: UISwipeGestureRecognizer.Direction) {
        let screenHeight = UIScreen.main.bounds.height
        let destinationUp = CGAffineTransform(translationX: 0, y: -screenHeight)
        
        let screenWidth = UIScreen.main.bounds.width
        let destinationLeft = CGAffineTransform(translationX: -screenWidth, y: 0)
        
        switch direction {
        case .up: sendGridView(destinationUp)
        case .left: sendGridView(destinationLeft)
        default: break
        }
    }
    
    private func sendGridView(_ transform: CGAffineTransform) {
        gridView.animation {
            self.gridView.transform = transform
        } completion: { (true) in
            self.shareGridView()
        }
    }
}

// MARK: - Share Grid
    
extension GridViewController {
        
    private func shareGridView() {
        let gridPicture = gridView.asImage()
        let activityController = UIActivityViewController(activityItems: [gridPicture],
                                                          applicationActivities: nil)
        self.present(activityController, animated: true)
        
        activityController.completionWithItemsHandler = { [self] (_, success, _, _) in
            if success {
                gridView.animation({
                    self.setUpGridView()
                    self.gridIsEmpty = true
                }, completion: nil)
            }
            gridView.animation({
                self.gridView.transform = .identity
            }, completion: nil)
        }
    }
}

// MARK: - Alert Empty Grid

extension GridViewController {
    
    func showAlertEmptyGrid(with direction: UISwipeGestureRecognizer.Direction) {
        let alertVC = UIAlertController(
            title: "Oups...!",
            message: "Do you want to share a grid without photos",
            preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share an empty grid", style: .destructive) { share in
            self.swipe(by: direction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertVC.addAction(shareAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true)
    }
}

