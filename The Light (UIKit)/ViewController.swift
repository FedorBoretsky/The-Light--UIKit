//
//  ViewController.swift
//  The Light (UIKit)
//
//  Created by Fedor Boretskiy on 18.01.2022.
//

import UIKit
import AVFoundation   // Camera light support.

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var screenLightButton: UIButton!
    @IBOutlet weak var trafficLightsButton: UIButton!
    @IBOutlet weak var cameraLightButton: UIButton!
    @IBOutlet weak var cameraAndScreenLightButton: UIButton!
    
    // MARK: - App Modes
    
    enum ApplicationMode {
        case screenLight
        case trafficLights
        case cameraLight
        case cameraAndScreenLight
    }
    
    // State values affect the interface.
    // Their change leads to an update.
    struct UIState {
        var mode: ApplicationMode = .screenLight
        var isScreenLightOn: Bool = true
        var isCameraLightOn: Bool = false
        var trafficLightsIndex: Int = 0
    }
    
    var state = UIState() {
        didSet { updateUI() }
    }
    
    // MARK: - Controller
    
    // Hide status bar.
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Update from state values
    
    func updateUI() {
        updateScreen()
        toggleTorch(on: state.isCameraLightOn)
        updateButtons()
    }
    
    fileprivate func updateScreen() {
        switch state.mode {
        case .screenLight:
            view.backgroundColor = state.isScreenLightOn ? .white : .black
        case .trafficLights:
            view.backgroundColor = trafficLightsPalette[state.trafficLightsIndex]
        case .cameraLight:
            view.backgroundColor = .black
        case .cameraAndScreenLight:
            view.backgroundColor = state.isScreenLightOn ? .white : .black
        }
    }
    
    func updateButtons() {
        
        // Color
        let tintColor = UIColor(white: 0.5, alpha: 1)
        screenLightButton.tintColor = tintColor
        trafficLightsButton.tintColor = tintColor
        cameraLightButton.tintColor = tintColor
        cameraAndScreenLightButton.tintColor = tintColor
        
        // Selection
        screenLightButton.setImage(
            UIImage(named: "Mode ScreenLight" + (state.mode == .screenLight ? " Selected" : "")),
            for: [])
        trafficLightsButton.setImage(
            UIImage(named: "Mode TrafficLights" + (state.mode == .trafficLights ? " Selected" : "")),
            for: [])
        cameraLightButton.setImage(
            UIImage(named: "Mode CameraLight" + (state.mode == .cameraLight ? " Selected" : "")),
            for: [])
        cameraAndScreenLightButton.setImage(
            UIImage(named: "Mode CameraAndScreenLight" + (state.mode == .cameraAndScreenLight ? " Selected" : "")),
            for: [])
    }
    
    // MARK: - Traffic lights support
    
    // Traffic light possible colors.
    let trafficLightsPalette = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9490196078, green: 0.9254901961, blue: 0.3490196078, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    
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
    
    // MARK: - Interaction
    
    @IBAction func tapScreen() {
        switch state.mode {
        case .screenLight:
            state.isScreenLightOn.toggle()
        case .trafficLights:
            state.trafficLightsIndex = trafficLightsNewIndex()
        case .cameraLight:
            state.isCameraLightOn.toggle()
        case .cameraAndScreenLight:
            state.isCameraLightOn.toggle()
            state.isScreenLightOn.toggle()
        }
    }

    func buttonActionForMode(_ tappedMode: ApplicationMode) {
        if tappedMode != state.mode {
            startMode(tappedMode)
        } else {
            tapScreen()
        }
    }
    
    @IBAction func screenModeTapped() {
        buttonActionForMode(.screenLight)
    }
    
    @IBAction func trafficLightsModeTapped() {
        buttonActionForMode(.trafficLights)
    }
    
    @IBAction func cameraLightModeTapped() {
        buttonActionForMode(.cameraLight)
    }
    
    @IBAction func cameraAndScreenLightModeTapped() {
        buttonActionForMode(.cameraAndScreenLight)
    }
    
    func startMode(_ newMode: ApplicationMode) {
        state.mode = newMode
        switch newMode {
        case .screenLight:
            state.isCameraLightOn = false
            state.isScreenLightOn = true
        case .trafficLights:
            state.isCameraLightOn = false
        case .cameraLight:
            state.isCameraLightOn = true
            state.isScreenLightOn = false
        case .cameraAndScreenLight:
            state.isCameraLightOn = true
            state.isScreenLightOn = true
        }
    }
}

