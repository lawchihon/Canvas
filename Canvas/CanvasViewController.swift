//
//  CanvasViewController.swift
//  Canvas
//
//  Created by John Law on 9/4/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!

    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        trayDownOffset = 200
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func springAnimation(trayMove: CGPoint) {
        UIView.animate(withDuration:0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options:[] ,
                       animations: { () -> Void in
                           self.trayView.center = trayMove
                       }, completion: nil)
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        // When the gesture begins, store the tray's center into the trayOriginalCenter variable
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        }
        // As the user pans, change the trayView.center by the translation.
        // Note: we ignore the x translation because we only want the tray to move up and down
        else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        // For the gesture end, check the y component of the velocity
        else if sender.state == .ended {
            // Clearing Transforms with Identity
            arrowImageView.transform = CGAffineTransform.identity

            // If the velocity.y is greater than 0, it's moving down.
            if velocity.y > 0 {
                arrowImageView.transform = arrowImageView.transform.rotated(by: CGFloat(M_PI))
                springAnimation(trayMove: self.trayDown)
            }
            else {
                springAnimation(trayMove: self.trayUp)
            }
        }
    }

    func scale(imageView: UIImageView, value: CGFloat) {
        UIView.animate(withDuration:0.4,
                       delay: 0.0,
                       options: [],
                       animations: {
                           () -> Void in
                           imageView.transform = CGAffineTransform(scaleX: value, y: value)
                       },
                       completion: nil)
    }
    
    func scaleUp(imageView: UIImageView) {
        scale(imageView: imageView, value: 2)
    }
    
    func scaleDown(imageView: UIImageView) {
        scale(imageView: imageView, value: 1)
    }
    
    func didPanNewFace(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        if sender.state == .began {
            // Get the face that we panned on.
            newlyCreatedFace = sender.view as! UIImageView
            // Offset by translation later
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            // Scale of the face to be a little larger
            scaleUp(imageView: newlyCreatedFace)
        }
        // In the changed state, pan the position of the newlyCreatedFace
        else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended {
            // Scale back to normal
            scaleDown(imageView: newlyCreatedFace)
        }
    }

    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        // In the began state, create a new image view that contains the same image as the view that was panned on
        if sender.state == .began {
            // imageView now refers to the face that panned on.
            let imageView = sender.view as! UIImageView
            // Create a new image view that has the same image as the one currently panning.
            newlyCreatedFace = UIImageView(image: imageView.image)
            // Add the new face to the main view.
            view.addSubview(newlyCreatedFace)
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            // Since the original face is in the tray, but the new face is in the main view, offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
            // Capture the initial center of the new face
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            // Scale of the face to be a little larger
            scaleUp(imageView: newlyCreatedFace)
        }
        // In the changed state, pan the position of the newlyCreatedFace
        else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended {
            // Scale back to normal
            scaleDown(imageView: newlyCreatedFace)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanNewFace(sender:)))
            
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
        }
    }
}
