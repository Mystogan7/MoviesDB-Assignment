//
//  AddNewMoviesViewController.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/23/19.
//

import UIKit

class AddNewMoviesViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImageFromPhotoLibrary))
            posterImageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    @IBOutlet weak var containerView: UIView! 
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var overViewTextField: UITextField!
    
    //MARK:- Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        intiateSaveButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
}

extension AddNewMoviesViewController {
    
    private func intiateSaveButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleAddedMovie))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    private func updateSaveButtonState() {
        guard let titleField = titleTextField else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        guard let dateField = dateTextField else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        guard let overViewField = overViewTextField else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        let enabled: Bool? = titleField.text?.isEmpty ?? false || dateField.text?.isEmpty ?? false || overViewField.text?.isEmpty ?? false
        self.navigationItem.rightBarButtonItem?.isEnabled = !enabled!
    }
    
    @objc private func selectImageFromPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        DispatchQueue.main.async {
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    @objc private func handleAddedMovie() {
        let selectedImageString = posterImageView.toString()
        let dictionary = ["id": Int.random(in: 0...999), "title": titleTextField.text ?? "", "poster_path": selectedImageString as Any, "release_date": dateTextField.text ?? "", "overview": overViewTextField.text ?? ""] as [String : Any]
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            NotificationCenter.default.post(name: Notifications.didSaveMovie.name, object: nil, userInfo: ["movie": movie])
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        } catch let error {
            fatalError("\(error)")
        }
    }
}



extension AddNewMoviesViewController: UITextFieldDelegate {
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide Keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
}

extension AddNewMoviesViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        DispatchQueue.main.async {
            self.posterImageView.image = selectedImage
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}

extension AddNewMoviesViewController: UINavigationControllerDelegate { }


