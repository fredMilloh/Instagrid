//
//  ViewController.swift
//  Instagrid
//
//  Created by fred on 02/08/2021.
//

import UIKit

class GridViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    var gridIsEmpty = true
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet var layoutSelectedImage: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        gridView.styleLayout = .layout2
        setStyleLayout(.layout2)
        selectImage()
    }

    // MARK: - IBActions
    
    @IBAction func switchLayout(_ sender: UIButton) {
        switch sender.tag {
        case 0: gridView.styleLayout = .layout1
            setStyleLayout(.layout1)
        case 1: gridView.styleLayout = .layout2
            setStyleLayout(.layout2)
        case 2: gridView.styleLayout = .layout3
            setStyleLayout(.layout3)
        default: break
        }
    }
    
    @IBAction func swipeGrid(_ sender: UISwipeGestureRecognizer) {
        if gridIsEmpty {
            showAlertEmptyGrid(with: sender.direction)
        } else {
            swipe(by: sender.direction)
        }
    }
}

// MARK: - Layout

extension GridViewController {
    
    private func setStyleLayout(_ style: StyleLayout) {
        switch style {
        case .layout1:
            hideLayoutSelectedImage()
            layoutSelectedImage[0].isHidden = false
        case .layout2:
            hideLayoutSelectedImage()
            layoutSelectedImage[1].isHidden = false
        case .layout3:
            hideLayoutSelectedImage()
            layoutSelectedImage[2].isHidden = false
        }
    }
    
    private func hideLayoutSelectedImage() {
        layoutSelectedImage.forEach { selectedImage in
            selectedImage.isHidden = true
        }
    }
}

// MARK: - ImagePicker

extension GridViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func selectImage() {
        gridView.currentButton = {
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            gridView.currentImage = selectedImage
            gridIsEmpty = false
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Swipe Grid

extension GridViewController {
    
    private func swipe(by direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .up: swipeUpGridView()
        case .left: swipeLeftGridView()
        default: break
        }
    }
    // Swipe Up
    private func swipeUpGridView() {
        let screenHeight = UIScreen.main.bounds.height
        let transform = CGAffineTransform(translationX: 0, y: -screenHeight)
        sendGridView(transform)
    }
    // Swipe Left
    private func swipeLeftGridView() {
        let screenWidth = UIScreen.main.bounds.width
        let transform = CGAffineTransform(translationX: -screenWidth, y: 0)
        sendGridView(transform)
    }

    private func sendGridView(_ transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5) {
            self.gridView.transform = transform
        } completion: { (true) in
            self.shareGridView()
        }
    }
}

// MARK: - Share Grid
    
extension GridViewController {
        
    private func shareGridView() {
    
        let gridPictures = gridView.asImage()
        let activityController = UIActivityViewController(activityItems: [gridPictures],
                                                          applicationActivities: nil)
        self.present(activityController, animated: true)
        // The completion handler to execute after the activity view controller is dismissed.DevDoc
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
                    self.gridView.transform = .identity
                    self.gridView.emptyGrid()
                    self.gridView.styleLayout = .layout2
                    self.setStyleLayout(.layout2)
                    self.gridIsEmpty = true
                }, completion: nil)
            }
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
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
