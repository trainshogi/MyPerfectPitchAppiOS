import SpriteKit
import GameplayKit

class ResultScene: SKScene {
	
	//MARK: Properties
	
	var score : Int?
	var message : String?
	var difficulty : String?
	
	private var title : SKLabelNode?
	private var difficultyNode : SKLabelNode?
	private var scoreNode : SKLabelNode?
	private var messageNode : SKLabelNode?
	private var retry : SKLabelNode?
	private var menu : SKLabelNode?
	
	private var spinnyNode : SKShapeNode?
	
	override func didMove(to view: SKView) {
		
		// Get label nodes from scene and store it for use later
		self.title = self.childNode(withName: "//title") as? SKLabelNode
		self.difficultyNode = self.childNode(withName: "//difficulty") as? SKLabelNode
		self.scoreNode = self.childNode(withName: "//score") as? SKLabelNode
		self.messageNode = self.childNode(withName: "//message") as? SKLabelNode
		self.retry = self.childNode(withName: "//retry") as? SKLabelNode
		self.menu = self.childNode(withName: "//return") as? SKLabelNode
		
		if let score = self.score {
			self.scoreNode?.text = String(score)
		}
		if let message = self.message {
			self.messageNode?.text = message
		}
		if let difficulty = self.difficulty {
			self.difficultyNode?.text = difficulty
		}
		appearAnimation()
		
		// Create shape node to use during mouse interaction
		let w = (self.size.width + self.size.height) * 0.05
		self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
		
		if let spinnyNode = self.spinnyNode {
			spinnyNode.lineWidth = 2.5
			
			spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
			spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
			                                  SKAction.fadeOut(withDuration: 0.5),
			                                  SKAction.removeFromParent()]))
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchDown(atPoint: t.location(in: self)) }
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
	}
	
	//MARK: Private Methods
	
	private func appearAnimation() {
		appearAnimation {
			print("appearAnimation() done.")
		}
	}
	
	private func appearAnimation(_ completion: @escaping () -> Void) {
		if let label = self.title {
			label.alpha = 0.0
			label.run(SKAction.fadeIn(withDuration: 1.0))
		}
		
		if let label = self.difficultyNode {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.2),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}
		
		if let label = self.scoreNode {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.4),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}
		
		if let label = self.messageNode {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.6),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}
		
		if let label = self.retry {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.8),
				SKAction.fadeIn(withDuration: 1.0)
			]))
		}
		
		if let label = self.menu {
			label.alpha = 0.0
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 1.0),
				SKAction.fadeIn(withDuration: 1.0)
			]), completion: completion)
		}
		
	}
	
	private func dismissAnimation() {
		dismissAnimation {
			print("dismissAnimation() done.")
		}
	}
	
	private func dismissAnimation(_ completion: @escaping () -> Void) {
		if let label = self.title {
			label.run(SKAction.fadeOut(withDuration: 1.0))
		}
		
		if let label = self.difficultyNode {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.2),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}
		
		if let label = self.scoreNode {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.4),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}
		
		if let label = self.messageNode {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.4),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}
		
		if let label = self.retry {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.8),
				SKAction.fadeOut(withDuration: 1.0)
			]))
		}
		
		if let label = self.menu {
			label.run(SKAction.sequence([
				SKAction.wait(forDuration: 1.0),
				SKAction.fadeOut(withDuration: 1.0)
			]), completion: completion)
		}
	}
	
	private func touchDown(atPoint pos : CGPoint) {
		if let n = self.spinnyNode?.copy() as! SKShapeNode? {
			n.position = pos
			n.strokeColor = SKColor.green
			self.addChild(n)
		}
	}
	
	private func touchMoved(toPoint pos : CGPoint) {
		if let n = self.spinnyNode?.copy() as! SKShapeNode? {
			n.position = pos
			n.strokeColor = SKColor.blue
			self.addChild(n)
		}
	}
	
	private func touchUp(atPoint pos : CGPoint) {
		if let n = self.spinnyNode?.copy() as! SKShapeNode? {
			n.position = pos
			n.strokeColor = SKColor.red
			self.addChild(n)
		}
		
		let node = self.nodes(at: pos).last
		if let name = node?.name {
			switch name {
			case "retry":
				if difficulty != nil {
					goToQuestionScene(difficulty!)
				}
				break
			case "return":
				goToStartMenuScene()
				break
			default:
				break
			}
		}
	}
	
	private func goToStartMenuScene() {
		if let scene = SKScene(fileNamed: "StartMenuScene") as? StartMenuScene {
			// Set the scale mode to scale to fit the window
			scene.scaleMode = .aspectFill
			
			dismissAnimation {
				// Present the scene
				self.view?.presentScene(scene)
			}
		}
	}
	
	private func goToQuestionScene(_ difficulty : String) {
		if let scene = SKScene(fileNamed: "QuestionScene") as? QuestionScene {
			scene.score = 0
			scene.difficulty = difficulty
			
			// Set the scale mode to scale to fit the window
			scene.scaleMode = .aspectFill
			
			dismissAnimation {
				// Present the scene
				self.view?.presentScene(scene)
			}
		}
	}
}
