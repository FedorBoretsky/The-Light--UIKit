//
//  toggleTorch.swift
//  The Light (UIKit)
//
//  Created by Fedor Boretskiy on 21.02.2022.
//
//  Switch on/off the camera flashlight.
//
//  Code pulled from Paul Hudson's article
//  «How to turn on the camera flashlight to make a torch»
//  https://www.hackingwithswift.com/example-code/media/how-to-turn-on-the-camera-flashlight-to-make-a-torch
//

import AVFoundation

/// Switch on/off the camera flashlight.
/// - Parameter on: The value to control the flashlight state.
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

