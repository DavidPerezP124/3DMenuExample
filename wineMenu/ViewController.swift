//
//  ViewController.swift
//  wineMenu
//
//  Created by David Perez on 2/20/19.
//  Copyright © 2019 David Perez P. All rights reserved.
//

import UIKit
import SceneKit
import QuartzCore
import ModelIO
import SceneKit.ModelIO

class ViewController: UIViewController {
    
    var scneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        setupTextures()
    }
    
    
    
    func setupSceneView(){
        scneView = view as! SCNView
        scneView.play(self)
        scneView.antialiasingMode = SCNAntialiasingMode.none
        scneView.showsStatistics = true
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gestureRecognize:)))
        scneView.addGestureRecognizer(panRecognizer)
    }
    
    func setupTextures(){
        
        let box = scneView.scene?.rootNode.childNode(withName: "box", recursively: true)
        let plane = scneView.scene?.rootNode.childNode(withName: "plane", recursively: true)
        let spot = scneView.scene?.rootNode.childNode(withName: "spot", recursively: true)
        
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIImage(named: "blackBoard.jpg")
        planeMaterial.isDoubleSided = true
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "blackWood.jpg")
        
        plane?.geometry?.firstMaterial = planeMaterial
        box?.geometry?.firstMaterial = material
        box?.geometry?.materials[1] = material
        let bottleMaterial = SCNMaterial()
        bottleMaterial.diffuse.contents  = UIImage(named: "Cork_Texture_by_faycop.jpg")
        let labelMaterial = SCNMaterial()
        labelMaterial.diffuse.contents = UIImage(named: "label_wine.png")
        let glassMaterial = SCNMaterial()
        glassMaterial.diffuse.contents = UIImage(named: "glassTexture.png")
        glassMaterial.transparent.contents = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
        glassMaterial.isDoubleSided = true
        
        guard let path = Bundle.main.path(forResource: "Wine_Bottle_Red", ofType: ".obj") else {return}
        let asset = MDLAsset(url: URL(fileURLWithPath: path))
        
        guard let object = asset.object(at: 0) as? MDLMesh else {return}
        let node = SCNNode(mdlObject: object)
        node.scale = SCNVector3(2, 2, 2)
        node.position = SCNVector3((box?.position.x)! + 0.1 , (box?.boundingBox.max.y)!, (box?.position.z)! + 0.2)
        node.rotation.x = -110
        node.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static, shape: nil)
        node.physicsBody?.categoryBitMask = 2
        
        node.physicsBody?.collisionBitMask = -3
        print(node.geometry?.materials)
        //node.geometry?.material(named: "Glass")?.setValue( (0,0,0,1) , forKey: "transparent")
        node.geometry?.materials[0] = glassMaterial
        node.geometry?.materials[1] = bottleMaterial
        node.geometry?.materials[2] = labelMaterial
        
        let x = Double((spot?.position.x)!)
        let y = Double((spot?.position.y)!)
        let z = Double((spot?.position.z)!)
        
        let spotAction = SCNAction.move(to: SCNVector3(
            x + 0.6,
            y + 0.6,
            z + 0.6
        ), duration: 0.5)
        let reverse = SCNAction.move(to: SCNVector3(
            x,
            y,
            z
            ), duration: 1)
        let printSpot = SCNAction.run { (_) in
            print(spot?.position)
        }
        let sequence = SCNAction.sequence([printSpot, spotAction, printSpot, reverse, printSpot])
        let sqncRepeat = SCNAction.repeatForever(sequence)
        
        spot?.runAction(sqncRepeat)
        
        print(spot?.position)
        
        box?.addChildNode(node)
        
    }
    
    @objc
    func panGesture(gestureRecognize: UIPanGestureRecognizer) {
        
        var lastPosition: SCNVector3?
        
        
        let point = gestureRecognize.translation(in: view)
        
        let state = gestureRecognize.state
        
        
        guard let text = scneView.scene?.rootNode.childNode(withName: "text", recursively: true) else {return}
        guard let plane = scneView.scene?.rootNode.childNode(withName: "plane", recursively: true) else {return}
        
        let translation = scneView.unprojectPoint(SCNVector3(-0.57, point.y, CGFloat(0.6)))
        
    //    let translation = scneView.projectPoint(SCNVector3(-0.57, point.y, CGFloat(0.447)))
        
        if (state == .failed || state == .cancelled) {
            return
        }
        
       
            lastPosition = translation
        
                if state == .began  {
                    
                } else if state ==  .changed  {
        
                    let deltaPos = text.position.y - translation.y
                 
                    text.position.y = translation.y + translation.y/2
                    print("translation", translation)
                    print("changed delta pos",deltaPos)
                    print(text.position)
                    
                }else if state == .ended {
                   return
                }
    }
    
    
}

