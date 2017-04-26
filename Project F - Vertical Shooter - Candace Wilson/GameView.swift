//
//  GameView.swift
//  Project F - Vertical Shooter - Candace Wilson
//
//  Created by Candace Wilson on 4/5/17.
//  Copyright © 2017 Candace Wilson. All rights reserved.
//

import SpriteKit;
import UIKit;

struct GamePiece
{
	static let Enemy : UInt32 = 1;
	static let Ammo : UInt32 = 2;
	static let Player : UInt32 = 3;
}

class GameView: SKScene, SKPhysicsContactDelegate
{
	var highScores : [String: Int] = [:];
	var score = Int();
	var player = SKSpriteNode(imageNamed: "pup.png");
	var scoreLabel = UILabel();
	var livesLabel = UILabel();
	var viewController: UIViewController?
	var enemy: SKSpriteNode = SKSpriteNode();
	var ammoSpawnTimer: Timer = Timer();
	var enemySpawnTimer: Timer = Timer();
	var lives: Int = 3;
	
	override func sceneDidLoad()
	{
		super.sceneDidLoad();
		
		let width = view!.frame.size.width; 
		let height = view!.frame.size.height;
		
		scoreLabel.text  = "Score: \(score)";
		scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width/2, height: height/16));
		scoreLabel.backgroundColor = UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 0.3);
		scoreLabel.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		scoreLabel.textColor = UIColor.white;
		view?.addSubview(scoreLabel);
		
		livesLabel.text  = "Lives Left: \(lives)";
		livesLabel = UILabel(frame: CGRect(x: width/2, y: 0, width: width/2, height: height/16));
		livesLabel.backgroundColor = UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 0.3);
		livesLabel.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		livesLabel.textColor = UIColor.white;
		view?.addSubview(livesLabel);
	}
	
	override func didMove(to view: SKView)
	{
//		let width = view.frame.size.width;
//		let height = view.frame.size.height;
//		
//		scoreLabel.text  = "Score: \(score)";
//		scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width/2, height: height/16));
//		scoreLabel.backgroundColor = UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 0.3);
//		scoreLabel.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
//		scoreLabel.textColor = UIColor.white;
//		view.addSubview(scoreLabel);
//		
//		livesLabel.text  = "Lives Left: \(lives)";
//		livesLabel = UILabel(frame: CGRect(x: width/2, y: 0, width: width/2, height: height/16));
//		livesLabel.backgroundColor = UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 0.3);
//		livesLabel.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
//		livesLabel.textColor = UIColor.white;
//		view.addSubview(livesLabel);
		
		var sortedScores : [String : Int] = [:];
		let HighScoreDefault = UserDefaults.standard;
		
		if (HighScoreDefault.dictionary(forKey: "HighScore") != nil)
		{
			highScores = (HighScoreDefault.dictionary(forKey: "HighScore") as? [String : Int])!;
			
			for (name,score) in (Array(highScores).sorted {$0.1 > $1.1})
			{
				sortedScores[name] = score;
			}
		}
		else
		{
			highScores = [:];
			sortedScores = [:];
		}
		
		physicsWorld.contactDelegate = self;
		
		scene?.backgroundColor = UIColor.black;
		scene?.size = CGSize(width: 640, height: 1136);
		
		player.position = CGPoint(x: size.width / 2, y: size.height / 5);
		player.physicsBody = SKPhysicsBody(rectangleOf: player.size);
		player.physicsBody?.affectedByGravity = false;
		player.physicsBody?.categoryBitMask = GamePiece.Player;
		player.physicsBody?.contactTestBitMask = GamePiece.Enemy;
		player.physicsBody?.isDynamic = false;
		
		ammoSpawnTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(SpawnAmmo), userInfo: nil, repeats: true);
		enemySpawnTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(SpawnEnemies), userInfo: nil, repeats: true);
		
		addChild(player);
		
		var emitterNode = starfieldEmitter(SKColor.white, starSpeedY: 50, starsPerSecond: 1, starScaleFactor: 0.2);
		emitterNode.zPosition = -10;
		addChild(emitterNode);
		
		emitterNode = starfieldEmitter(SKColor.lightGray, starSpeedY: 30, starsPerSecond: 2, starScaleFactor: 0.1);
		emitterNode.zPosition = -11;
		addChild(emitterNode);
		
		emitterNode = starfieldEmitter(SKColor.gray, starSpeedY: 15, starsPerSecond: 4, starScaleFactor: 0.05);
		emitterNode.zPosition = -12;
		addChild(emitterNode);
	}
	
	func starfieldEmitter(_ color: SKColor, starSpeedY: CGFloat, starsPerSecond: CGFloat, starScaleFactor: CGFloat) -> SKEmitterNode
	{
		let lifetime =  frame.size.height * UIScreen.main.scale / starSpeedY;
		
		let emitterNode = SKEmitterNode();
		emitterNode.particleTexture = SKTexture(imageNamed: "star.png");
		emitterNode.particleBirthRate = starsPerSecond;
		emitterNode.particleColor = SKColor.lightGray;
		emitterNode.particleSpeed = starSpeedY * -1;
		emitterNode.particleScale = starScaleFactor;
		emitterNode.particleColorBlendFactor = 1;
		emitterNode.particleLifetime = lifetime;
		
		emitterNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height);
		emitterNode.particlePositionRange = CGVector(dx: frame.size.width, dy: 0);
		
		emitterNode.advanceSimulationTime(TimeInterval(lifetime));
		
		return emitterNode;
	}
	
	func didBegin(_ contact: SKPhysicsContact)
	{
		let firstBody : SKPhysicsBody = contact.bodyA;
		let secondBody : SKPhysicsBody = contact.bodyB;
		
		if ((firstBody.categoryBitMask == GamePiece.Enemy) && (secondBody.categoryBitMask == GamePiece.Ammo))
		{
			CollisionWithAmmo(firstBody.node as! SKSpriteNode, Ammo: secondBody.node as! SKSpriteNode);
		}
		else if((firstBody.categoryBitMask == GamePiece.Ammo) && (secondBody.categoryBitMask == GamePiece.Enemy))
		{
			CollisionWithAmmo(secondBody.node as! SKSpriteNode, Ammo: firstBody.node as! SKSpriteNode);
		}
		else if ((firstBody.categoryBitMask == GamePiece.Enemy) && (secondBody.categoryBitMask == GamePiece.Player))
		{
			CollisionWithPlayer(firstBody.node as! SKSpriteNode, Player: secondBody.node as! SKSpriteNode);
		}
		else if((firstBody.categoryBitMask == GamePiece.Player) && (secondBody.categoryBitMask == GamePiece.Enemy))
		{
			CollisionWithPlayer(secondBody.node as! SKSpriteNode, Player: firstBody.node as! SKSpriteNode);
		}
	}
	
	func CollisionWithAmmo(_ Enemy: SKSpriteNode, Ammo: SKSpriteNode)
	{
		Enemy.physicsBody?.categoryBitMask = 0;
		Enemy.texture = SKTexture(imageNamed: "explosion.png");
		enemy = Enemy;
		
		let fade = SKAction.fadeAlpha(to: 0, duration: 0.5);
		Enemy.run(fade);
		
		Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(EnemyDestroyed), userInfo: nil, repeats: false);
		
		Ammo.removeFromParent();
		
		score += 1;
		scoreLabel.text = "Score: \(score)";
	}
	
	func CollisionWithPlayer(_ Enemy:SKSpriteNode, Player: SKSpriteNode)
	{
		lives -= 1;
		livesLabel.text = "Lives Left: \(lives)";

		if(lives > 0)
		{
			ammoSpawnTimer.invalidate();
			player.texture = SKTexture(imageNamed: "pupHit.png");
			Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerHit), userInfo: nil, repeats: false);
		}
		else
		{
			let ScoreDefault = UserDefaults.standard;
			ScoreDefault.setValue(score, forKey: "Score");
			ScoreDefault.synchronize();
			
			var sortedScores : [String : Int] = [:];
			var count : Int = 0;
			
			let date = Date();
			let calendar = Calendar.current;
			let year = calendar.component(.year, from: date);
			let month = calendar.component(.month, from: date);
			let day = calendar.component(.day, from: date);
			let hour = calendar.component(.hour, from: date);
			let minute = calendar.component(.minute, from: date);
			let second = calendar.component(.second, from: date);
			
			let uniquePlayerId: String = String(year) + String(month) + String(day) + String(hour) + String(minute) + String(second);
			let UniquePlayerId = UserDefaults.standard;
			UniquePlayerId.setValue(uniquePlayerId, forKey: "UniquePlayerId");
			
			highScores[uniquePlayerId] = score;
			
			for (name,score) in (Array(highScores).sorted {$0.1 > $1.1})
			{
				if(count < 5)
				{
					sortedScores[name] = score;
					count = count + 1;
				}
			}
			
			let HighscoreDefault = UserDefaults.standard;
			HighscoreDefault.setValue(sortedScores, forKey: "HighScore");
			
			ammoSpawnTimer.invalidate();
			enemySpawnTimer.invalidate();
			
			Enemy.texture = SKTexture(imageNamed: "explosion.png");
			Player.texture = SKTexture(imageNamed: "explosion.png");
			
			let fade = SKAction.fadeAlpha(to: 0, duration: 2);
			
			enemy = Enemy;
			player = Player;
			
			player.run(fade);
			enemy.run(fade);
			
			Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(PlayerDestroyed), userInfo: nil, repeats: false);
		}
	}
	
	func PlayerHit()
	{
		player.texture = SKTexture(imageNamed: "pup.png");
		ammoSpawnTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(SpawnAmmo), userInfo: nil, repeats: true);
	}
	
	func EnemyDestroyed()
	{
		enemy.removeFromParent();
	}
	
	func PlayerDestroyed()
	{
		player.removeFromParent();
		enemy.removeFromParent();
		
		let gameOverView = GameOverView();
		gameOverView.viewController = self.viewController;
		view?.presentScene(gameOverView);
		livesLabel.removeFromSuperview();
		scoreLabel.removeFromSuperview();
	}
	
	func SpawnAmmo()
	{
		let Ammo = SKSpriteNode(imageNamed: "treat.png");
		Ammo.zPosition = -5;
		
		Ammo.position = CGPoint(x: player.position.x, y: player.position.y);
		
		let action = SKAction.moveTo(y: size.height + 30, duration: 0.8);
		let actionDone = SKAction.removeFromParent();
		Ammo.run(SKAction.sequence([action, actionDone]));
		
		Ammo.physicsBody = SKPhysicsBody(rectangleOf: Ammo.size);
		Ammo.physicsBody?.categoryBitMask = GamePiece.Ammo;
		Ammo.physicsBody?.contactTestBitMask = GamePiece.Enemy;
		Ammo.physicsBody?.affectedByGravity = false;
		Ammo.physicsBody?.isDynamic = false;
		addChild(Ammo);
	}
	
	func SpawnEnemies()
	{
		let Enemy = SKSpriteNode(imageNamed: "cat.png");
		let MinValue: CGFloat = 0;
		let MaxValue = size.width;
		let SpawnPoint = UInt32(MaxValue - MinValue);
		
		Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint)), y: size.height);
		Enemy.physicsBody = SKPhysicsBody(rectangleOf: Enemy.size);
		Enemy.physicsBody?.categoryBitMask = GamePiece.Enemy;
		Enemy.physicsBody?.contactTestBitMask = GamePiece.Ammo;
		Enemy.physicsBody?.affectedByGravity = false;
		Enemy.physicsBody?.isDynamic = true;
		
		let action = SKAction.moveTo(y: -70, duration: 2.0);
		let actionDone = SKAction.removeFromParent();
		Enemy.run(SKAction.sequence([action, actionDone]));
		
		addChild(Enemy);
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		for touch: AnyObject in touches
		{
			let location = touch.location(in: self);
			player.position.x = location.x;
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		for touch: AnyObject in touches
		{
			let location = touch.location(in: self);
			player.position.x = location.x;
		}
	}
	
	override func update(_ currentTime: TimeInterval) {
	}
}
