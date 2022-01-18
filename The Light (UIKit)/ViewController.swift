//
//  ViewController.swift
//  The Light (UIKit)
//
//  Created by Fedor Boretskiy on 18.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // State values affect the interface.
    // Their change leads to an update.
    var state = (
        isLightOn: Bool(true),
        lightColor: UIColor.white
    ) {
        didSet { updateUI() }
    }
    
    // Hide status bar.
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func tapScreen() {
        state.isLightOn.toggle()
    }
    
    func updateUI() {
        view.backgroundColor = state.isLightOn ? state.lightColor : .black
    }
    
}

