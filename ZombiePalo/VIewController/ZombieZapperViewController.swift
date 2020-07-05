//
//  zombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import UIKit
import ARKit

class ZombieZapperViewController: UIViewController{

    @IBOutlet weak var sceneView: ARSCNView!
    
    let zombieHouse = ["zombieRed","zombieGreen"]
    
    let scene = SCNScene()
    
    var gameTimer: Timer?
    
    let maxZombies = 5
    var zombieCount = 0
    var zombieZap = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.scene = scene

        addTapGestureToSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reset()
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical,.horizontal]

        sceneView.session.run(configuration)
        
        startTimer()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopTimer()
        
        sceneView.session.pause()
    }
    
    func startTimer(){
        guard gameTimer == nil else { return }
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(Int.random(in: 3..<7)), target: self, selector: #selector(cloneZombie), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
      gameTimer?.invalidate()
      gameTimer = nil
    }
    
    @objc func cloneZombie(){
        if let node = addImage(named: zombieHouse[Int.random(in: 0..<zombieHouse.count)]) {
            sceneView.scene.rootNode.addChildNode(node)
        }
    }

    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {
            return
        }
        zombieZap += 1
        node.removeFromParentNode()
    }
    
    func addImage(named: String) -> SCNNode? {
        if zombieCount == maxZombies {
            performSegue(withIdentifier: "scoreSegue", sender: nil)
            return nil
        }
        
        let imageNode = SCNNode()
        let imagePlane = SCNPlane(width: CGFloat.random(in: 5..<20), height: CGFloat.random(in: 5..<20))
        let imageImage = UIImage(named: named)
        let imageImageView = UIImageView(image: imageImage)
        imagePlane.firstMaterial?.diffuse.contents = imageImageView
        imageNode.geometry = imagePlane
        imageNode.position = SCNVector3(Int.random(in: 5..<20), Int.random(in: 1..<3), -(Int.random(in: 10..<20)))
      
        let action = SCNAction.rotateBy(x: CGFloat(GLKMathDegreesToRadians(Float(Int.random(in: 45..<180)))), y: CGFloat(GLKMathDegreesToRadians(45)), z: CGFloat(GLKMathDegreesToRadians(45)), duration: 5)
        let forever = SCNAction.repeatForever(action)
        imageNode.runAction(forever)
        zombieCount += 1
      return imageNode
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destViewController = segue.destination as? ZombieScoreViewController {
            destViewController.delegate = self
            destViewController.score = zombieZap
            destViewController.message = "You were overcome by \(String(maxZombies)) zombies"
       }
    }

   
}

extension ZombieZapperViewController : ARSCNViewDelegate{
    
    
}

extension ZombieZapperViewController : zombieScoreDelegate {
    func reset() {
        zombieCount = 0
        zombieZap = 0
    }

}
