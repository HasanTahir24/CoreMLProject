//
//  ViewController.swift
//  CoreMLProject
//
//  Created by Hasan on 7/12/18.
//  Copyright © 2018 Hasan. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var digitlabel: UILabel!
    @IBOutlet weak var canvasview: CanvasView!
    
    var requests=[VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupvision()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupvision(){
            print("hi2")
        guard let visionModel = try? VNCoreMLModel(for: MNIST().model)else{fatalError("cannot load Vision Model")}
        let classificationrequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleclassification)
      self.requests=[classificationrequest]
    }
    
    func handleclassification(request:VNRequest,error:Error?){
           print("hi")
        guard let observations = request.results else { print("No result")
       return }
        print(observations)
        let classications=observations
            
            .flatMap({$0 as? VNClassificationObservation})
            .filter({$0.confidence>0.1})
        .map({$0.identifier})
        DispatchQueue.main.async {
            print(classications)
            self.digitlabel.text=classications.first
         
        }
    }

    @IBAction func ClearView(_ sender: Any) {
         //setupvision()
        canvasview.clearCanvas()
    }
    @IBAction func RecognizePattern(_ sender: Any){
      print("hi3")
      var s="sds"
       
      let image=UIImage(view: canvasview)
        let scaledimage=self.scaleImage(image: image, toSize: CGSize(width: 28, height: 28))
        let imageRequestHandler = VNImageRequestHandler(cgImage: scaledimage.cgImage!, options: [:])
        do{
            try imageRequestHandler.perform(self.requests)
            //  setupvision()
        }
        catch{
            print(error)
        }
    }
    func scaleImage(image:UIImage,toSize size:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}


