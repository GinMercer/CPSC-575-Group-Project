//
//  ViewController.swift
//  FoodApp
//
//  Created by Lan Jin on 2020-10-21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false //can be ture if we want the user to zoom in the pic
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedImage
            
            guard let CIimage = CIImage(image: userPickedImage) else{
                fatalError("Could not convert the UIimage into CIimage!")
            }
            
            detect(image: CIimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: chineseFoodLookUp_3().model) else{
            fatalError("Loading CoreML Model failed!")
        }
    
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model failed to process message")
            }
            
            print(results)
            if let firstResult = results.first{
                if firstResult.identifier.contains("Laoganma"){
                    self.navigationItem.title = "Laoganma"
                }else if firstResult.identifier.contains("Zhimajiang"){
                    self.navigationItem.title = "Zhimajiang"
                }else if firstResult.identifier.contains("Zhen Jiang Xiang Cu"){
                    self.navigationItem.title = "Zhen Jiang Xiang Cu"
                }
            }
            
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }
        catch {
            print(error)
        }
       
        
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

