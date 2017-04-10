//
//  CanvasViewController.swift
//  Canvas
//
//  Created by John Law on 9/4/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
var trayOriginalCenter: CGPoint!

class CanvasViewController: UIViewController {
    @IBOutlet weak var trayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        trayOriginalCenter = trayView.center
        trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
    }
}
