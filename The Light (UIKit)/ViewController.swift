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
    
    // MARK: - App modes and state
    
    enum Mode {
        case screenLight
        case trafficLights
        case cameraLight
        case cameraAndScreenLight
    }
    
    // State values affect the interface.
    // Their change leads to an update.
    struct UIState {
        var mode: Mode = .screenLight
        var isScreenLightOn: Bool = true
        var isCameraLightOn: Bool = false
        var trafficLightsIndex: Int = 0
    }
    
    var uiState = UIState() {
        didSet { updateUI() }
    }
    
    // MARK: - Setup
    
    // Hide status bar.
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonsSelectedState()
        updateUI()
    }
    
    func setButtonsSelectedState() {
        screenLightButton.setImage(UIImage(named: "Mode ScreenLight Selected"), for: .selected)
        trafficLightsButton.setImage(UIImage(named: "Mode TrafficLights Selected"), for: .selected)
        cameraLightButton.setImage(UIImage(named: "Mode CameraLight Selected"), for: .selected)
        cameraAndScreenLightButton.setImage(UIImage(named: "Mode CameraAndScreenLight Selected"), for: .selected)
    }
    
    // MARK: - Update from state values
    
    func updateUI() {
        updateScreen()
        toggleTorch(on: uiState.isCameraLightOn)
        updateButtons()
    }
    
    fileprivate func updateScreen() {
        switch uiState.mode {
        case .screenLight:
            view.backgroundColor = uiState.isScreenLightOn ? .white : .black
        case .trafficLights:
            view.backgroundColor = trafficLightsBackgroundPalette[uiState.trafficLightsIndex]
        case .cameraLight:
            view.backgroundColor = .black
        case .cameraAndScreenLight:
            view.backgroundColor = uiState.isScreenLightOn ? .white : .black
        }
    }
    
    func updateButtons() {
        
        // Color
        let tintColor: UIColor
        if uiState.mode == .trafficLights {
            tintColor = trafficLightsIconPalette[uiState.trafficLightsIndex]
        } else {
            tintColor = UIColor(white: 0.5, alpha: 1)
        }
        screenLightButton.tintColor = tintColor
        trafficLightsButton.tintColor = tintColor
        cameraLightButton.tintColor = tintColor
        cameraAndScreenLightButton.tintColor = tintColor
        
        // Selection
        screenLightButton.isSelected = (uiState.mode == .screenLight)
        trafficLightsButton.isSelected = (uiState.mode == .trafficLights)
        cameraLightButton.isSelected = (uiState.mode == .cameraLight)
        cameraAndScreenLightButton.isSelected = (uiState.mode == .cameraAndScreenLight)
    }
    
    // MARK: - Traffic lights support
    
    // Traffic light possible colors.
    let trafficLightsBackgroundPalette = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9490196078, green: 0.9254901961, blue: 0.3490196078, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    let trafficLightsIconPalette = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7790220147), UIColor(white: 0.5, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7790220147)]

    // Cycles through colors.
    func trafficLightsNewIndex() -> Int {
        let nextIndex = uiState.trafficLightsIndex + 1
        return (nextIndex < trafficLightsBackgroundPalette.count) ? nextIndex : 0
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
        switch uiState.mode {
        case .screenLight:
            uiState.isScreenLightOn.toggle()
        case .trafficLights:
            uiState.trafficLightsIndex = trafficLightsNewIndex()
        case .cameraLight:
            uiState.isCameraLightOn.toggle()
        case .cameraAndScreenLight:
            uiState.isCameraLightOn.toggle()
            uiState.isScreenLightOn.toggle()
        }
    }

    func buttonActionForMode(_ tappedMode: Mode) {
        if tappedMode != uiState.mode {
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
    
    func startMode(_ newMode: Mode) {
        uiState.mode = newMode
        switch newMode {
        case .screenLight:
            uiState.isCameraLightOn = false
            uiState.isScreenLightOn = true
        case .trafficLights:
            uiState.isCameraLightOn = false
        case .cameraLight:
            uiState.isCameraLightOn = true
            uiState.isScreenLightOn = false
        case .cameraAndScreenLight:
            uiState.isCameraLightOn = true
            uiState.isScreenLightOn = true
        }
    }
}

