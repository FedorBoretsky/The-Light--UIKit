//
//  ViewController.swift
//  The Light (UIKit)
//
//  Created by Fedor Boretskiy on 18.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var screenSimpleLightButton: UIButton!
    @IBOutlet weak var screenTrafficLightsButton: UIButton!
    @IBOutlet weak var cameraLightButton: UIButton!
    @IBOutlet weak var cameraAndScreenLightsButton: UIButton!
    
    // MARK: - App modes and state
    
    enum Mode {
        case screenSimpleLight
        case screenTrafficLights
        case cameraLight
        case cameraAndScreenLights
    }
    
    // State values affect the interface.
    // Their change leads to an update.
    struct UIState {
        var mode: Mode = .screenSimpleLight
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
        screenSimpleLightButton.setImage(UIImage(named: "ScreenSimpleLight (Selected)"), for: .selected)
        screenTrafficLightsButton.setImage(UIImage(named: "ScreenTrafficLights (Selected)"), for: .selected)
        cameraLightButton.setImage(UIImage(named: "CameraLight (Selected)"), for: .selected)
        cameraAndScreenLightsButton.setImage(UIImage(named: "CameraAndScreenLights (Selected)"), for: .selected)
    }
    
    // MARK: - Update from state values
    
    func updateUI() {
        updateScreenLight()
        updateCameraLight()
        updateButtons()
    }
    
    func updateScreenLight() {
        switch uiState.mode {
        case .screenSimpleLight:
            view.backgroundColor = uiState.isScreenLightOn ? .white : .black
        case .screenTrafficLights:
            view.backgroundColor = trafficLightsColors[uiState.trafficLightsIndex].backgroundColor
        case .cameraLight:
            view.backgroundColor = .black
        case .cameraAndScreenLights:
            view.backgroundColor = uiState.isScreenLightOn ? .white : .black
        }
    }
    
    func updateCameraLight() {
        toggleTorch(on: uiState.isCameraLightOn)
    }
    
    func updateButtons() {
        
        // Color
        let tintColor: UIColor
        if uiState.mode == .screenTrafficLights {
            tintColor = trafficLightsColors[uiState.trafficLightsIndex].iconColor
        } else {
            tintColor = UIColor(white: 0.5, alpha: 1)
        }
        screenSimpleLightButton.tintColor = tintColor
        screenTrafficLightsButton.tintColor = tintColor
        cameraLightButton.tintColor = tintColor
        cameraAndScreenLightsButton.tintColor = tintColor
        
        // Selection
        screenSimpleLightButton.isSelected = (uiState.mode == .screenSimpleLight)
        screenTrafficLightsButton.isSelected = (uiState.mode == .screenTrafficLights)
        cameraLightButton.isSelected = (uiState.mode == .cameraLight)
        cameraAndScreenLightsButton.isSelected = (uiState.mode == .cameraAndScreenLights)
    }
    
    // MARK: - Traffic lights support
    
    struct BacgroundIconColorPair {
        let backgroundColor: UIColor
        let iconColor: UIColor
    }
    
    // Traffic light colors.
    let trafficLightsColors: [BacgroundIconColorPair] = [
        BacgroundIconColorPair(backgroundColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), iconColor: UIColor(white: 1, alpha: 0.78)),
        BacgroundIconColorPair(backgroundColor: #colorLiteral(red: 0.9490196078, green: 0.9254901961, blue: 0.3490196078, alpha: 1), iconColor: UIColor(white: 0.5, alpha: 1)),
        BacgroundIconColorPair(backgroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), iconColor: UIColor(white: 1, alpha: 0.78))
    ]
        
    // Cycling through colors.
    func trafficLightsSwitchIndex() -> Int {
        let next = uiState.trafficLightsIndex + 1
        return (next < trafficLightsColors.count) ? next : 0
    }
    
    
    // MARK: - Interaction
    
    @IBAction func tapScreen() {
        switch uiState.mode {
        case .screenSimpleLight:
            uiState.isScreenLightOn.toggle()
        case .screenTrafficLights:
            uiState.trafficLightsIndex = trafficLightsSwitchIndex()
        case .cameraLight:
            uiState.isCameraLightOn.toggle()
        case .cameraAndScreenLights:
            uiState.isCameraLightOn.toggle()
            uiState.isScreenLightOn = uiState.isCameraLightOn
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
        buttonActionForMode(.screenSimpleLight)
    }
    
    @IBAction func trafficLightsModeTapped() {
        buttonActionForMode(.screenTrafficLights)
    }
    
    @IBAction func cameraLightModeTapped() {
        buttonActionForMode(.cameraLight)
    }
    
    @IBAction func cameraAndScreenLightModeTapped() {
        buttonActionForMode(.cameraAndScreenLights)
    }
    
    func startMode(_ newMode: Mode) {
        uiState.mode = newMode
        switch newMode {
        case .screenSimpleLight:
            uiState.isCameraLightOn = false
            uiState.isScreenLightOn = true
        case .screenTrafficLights:
            uiState.isCameraLightOn = false
        case .cameraLight:
            uiState.isCameraLightOn = true
            uiState.isScreenLightOn = false
        case .cameraAndScreenLights:
            uiState.isCameraLightOn = true
            uiState.isScreenLightOn = uiState.isCameraLightOn
        }
    }
}

