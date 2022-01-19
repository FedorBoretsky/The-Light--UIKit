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
        mode: TheLightModes.trafficLights,
        isSimpleLightOn: true,
        trafficLightsCurrentIndex: 0
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
        switch state.mode{
        case .simpleLight:
            state.isSimpleLightOn.toggle()
        case .trafficLights:
            trafficLightsSwitchToNext()
        case .cameraLight:
            break
        }
    }
    
    func updateUI() {
        switch state.mode {
        case .simpleLight:
            view.backgroundColor = state.isSimpleLightOn ? .white : .black
        case .trafficLights:
            view.backgroundColor = trafficLightsPalette[state.trafficLightsCurrentIndex]
        case .cameraLight:
            view.backgroundColor = .black
        }
    }
    
    // MARK: - Modes support
    
    enum TheLightModes {
        case simpleLight
        case trafficLights
        case cameraLight
    }
    
    // MARK: - Traffic lights support
    
    // Traffic light possible colors
    let trafficLightsPalette = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9492518878, green: 0.9250498484, blue: 0.3488543158, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    
    // Switch pointer to next color.
    func trafficLightsSwitchToNext() {
        if state.trafficLightsCurrentIndex < trafficLightsPalette.count - 1 {
            state.trafficLightsCurrentIndex += 1
        } else {
            state.trafficLightsCurrentIndex = 0
        }
    }
    
}

