//
//  EditingModeView.swift
//  ARWorld
//
//  Created by TSD040 on 2018-02-07.
//  Copyright © 2018 sudo-world. All rights reserved.
//

import UIKit

protocol EditingModeViewDelegate: class {
    func editTapped(screenCoordinates: CGPoint)
    
    func editPanDidBegin(screenCoordinates: CGPoint)
    func editPanDidChange(screenCoordinates: CGPoint)
    func editPanDidEnd(screenCoordinates: CGPoint)

    func pinchDidBegin(scale: CGFloat)
    func pinchDidChange(scale: CGFloat)
    func pinchDidEnd(scale: CGFloat)
    
    func rotationDidBegin(rotation: CGFloat)
    func rotationDidChange(rotation: CGFloat)
    func rotationDidEnd(rotation: CGFloat)
    
    func doneButtonPressed()
    func trashButtonPressed()
}

class EditingModeView: UIView {

    @IBOutlet weak var view: UIView!
//    @IBOutlet weak var rotationGestureRecognizer: UIRotationGestureRecognizer!
//    @IBOutlet weak var pinchGestureRecognizer: UIPinchGestureRecognizer!
//    @IBOutlet weak var panGestureRecognizer: UIPanGestureRecognizer!
//    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    weak var delegate: EditingModeViewDelegate?
    
    var previousRotation: CGFloat? // set to nil when editing completes
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        delegate?.doneButtonPressed()
    }
    
    @IBAction func TrashButtonPressed(_ sender: UIButton) {
        delegate?.trashButtonPressed()
    }
    
//    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
//        delegate?.didTap(screenCoordinates: sender.location(in: view))
//    }
    
}

extension EditingModeView: ARModeView {
    func panGestureDidChange(_ gestureRecognizer: UIPanGestureRecognizer, screenCoordinates: CGPoint) {
        switch gestureRecognizer.state {
        case .began:
            //            tapGestureRecognizer.isEnabled = false
            //            pinchGestureRecognizer.isEnabled = false
            //            rotationGestureRecognizer.isEnabled = false
            if gestureRecognizer.numberOfTouches >= 1 {
                delegate?.editPanDidChange(screenCoordinates: gestureRecognizer.location(ofTouch: 0, in: view))
            }
            break
        case .changed:
            if gestureRecognizer.numberOfTouches >= 1 {
                delegate?.editPanDidChange(screenCoordinates: gestureRecognizer.location(ofTouch: 0, in: view))
            }
            break
        case .ended, .cancelled:
            //            delegate?.editPanDidEnd(screenCoordinates: sender.location(in: view))
            //            tapGestureRecognizer.isEnabled = true
            //            pinchGestureRecognizer.isEnabled = true
            //            rotationGestureRecognizer.isEnabled = true
            
            if gestureRecognizer.numberOfTouches >= 1 {
                delegate?.editPanDidEnd(screenCoordinates: gestureRecognizer.location(ofTouch: 0, in: view))
            }
            break
        default:
            break
        }
    }
    
    func tapGestureDidChange(_ gestureRecognizer: UITapGestureRecognizer, screenCoordinates: CGPoint) {
        delegate?.editTapped(screenCoordinates: gestureRecognizer.location(in: view))
    }
    
    func rotationGestureDidChange(_ gestureRecognizer: UIRotationGestureRecognizer) {
        print("rotation gesture received \(gestureRecognizer.state.rawValue)")
        switch gestureRecognizer.state {
        case .began:
            //            tapGestureRecognizer.isEnabled = false
            //            pinchGestureRecognizer.isEnabled = false
            //            panGestureRecognizer.isEnabled = false
            previousRotation = gestureRecognizer.rotation
            delegate?.rotationDidBegin(rotation: gestureRecognizer.rotation)
            break
        case .changed:
            
            delegate?.rotationDidChange(rotation: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0

            break
        case .ended, .cancelled:
            delegate?.rotationDidEnd(rotation: gestureRecognizer.rotation)
            //            tapGestureRecognizer.isEnabled = true
            //            pinchGestureRecognizer.isEnabled = true
            //            panGestureRecognizer.isEnabled = true
            break
        default:
            break
        }
    }
    
    func pinchGestureDidChange(_ gestureRecognizer: UIPinchGestureRecognizer) {
        print("pinch gesture recieved \(gestureRecognizer.state.rawValue) \(gestureRecognizer.location(in: self))")
        switch gestureRecognizer.state {
        case .began:
            //            tapGestureRecognizer.isEnabled = false
            //            rotationGestureRecognizer.isEnabled = false
            //            panGestureRecognizer.isEnabled = false
            delegate?.pinchDidBegin(scale: gestureRecognizer.scale)
            break
        case .changed:
            delegate?.pinchDidChange(scale: gestureRecognizer.scale)
            break
        case .ended, .cancelled:
            delegate?.pinchDidEnd(scale: gestureRecognizer.scale)
            //            tapGestureRecognizer.isEnabled = true
            //            rotationGestureRecognizer.isEnabled = true
            //            panGestureRecognizer.isEnabled = true
            break
        default:
            break
        }
    }
}
