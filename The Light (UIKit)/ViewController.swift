//
//  ViewController.swift
//  The Light (UIKit)
//
//  Created by Fedor Boretskiy on 18.01.2022.
//

import UIKit
import AVFoundation   // Camera light support.

class ViewController: UIViewController {
    
    enum appModes {
        case simpleLight
        case trafficLights
        case cameraLight
    }
    
    // State values affect the interface.
    // Their change leads to an update.
    var state = (
        mode: appModes.cameraLight,
        isSimpleLightOn: true,
        trafficLightsIndex: 0,
        isCameraLightOn: false
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
    
    // MARK: - Interaction
    
    @IBAction func tapScreen() {
        switch state.mode{
        case .simpleLight:
            // Black-white cycle.
            state.isSimpleLightOn.toggle()
        case .trafficLights:
            // Red-Yellow-Green cycle.
            state.trafficLightsIndex = trafficLightsNewIndex()
        case .cameraLight:
            state.isCameraLightOn.toggle()
        }
    }
    
    // MARK: - Update from state values
    
    func updateUI() {
        switch state.mode {
        case .simpleLight:
            view.backgroundColor = state.isSimpleLightOn ? .white : .black
        case .trafficLights:
            view.backgroundColor = trafficLightsPalette[state.trafficLightsIndex]
        case .cameraLight:
            view.backgroundColor = .black
            toggleTorch(on: state.isCameraLightOn)
        }
    }
    
    // MARK: - Traffic lights support
    
    // Traffic light possible colors.
    let trafficLightsPalette = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9492518878, green: 0.9250498484, blue: 0.3488543158, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    
    // Cycles through colors.
    func trafficLightsNewIndex() -> Int {
        let nextIndex = state.trafficLightsIndex + 1
        return (nextIndex < trafficLightsPalette.count) ? nextIndex : 0
    }
    
    // MARK: - Camera light support
    
    //
    //
    // Source of the code and details:
    // https://www.hackingwithswift.com/example-code/media/how-to-turn-on-the-camera-flashlight-to-make-a-torch
    //
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
}

