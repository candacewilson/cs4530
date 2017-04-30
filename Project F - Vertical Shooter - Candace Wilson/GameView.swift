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
	var score: Int = 0;
	var player = SKSpriteNode(imageNamed: "pup.png");
	var scoreLabel = UILabel();
	var livesLabel = UILabel();
	var levelLabel = UILabel();
	var viewController: UIViewController?
	var enemy: SKSpriteNode = SKSpriteNode();
	var ammoSpawnTimer: Timer = Timer();
	var enemySpawnTimer: Timer = Timer();
	var spawnRate: Double = 0.7;
	var lives: Int = 3;
	var level: Int = 1;
	var levelIncrease: Int = 10;
	
	override func didMove(to view: SKView)
	{
		let width = view.frame.size.width;
		let height = view.frame.size.height;
		
		scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width/3, height: height/16));
		scoreLabel.backgroundColor = UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 0.3);
		scoreLabel.text = "Score: \(score)";
		scoreLabel.font = UIFont(name:"GillSans-UltraBold", size: 15.0);
		scoreLabel.textAlignment = NSTextAlignment.center;
		scoreLabel.textColor = UIColor.white;
		
		levelLabel = UILabel(frame: CGRect(x: width/3, y: 0, width: width/3, height: height/16));
		levelLabel.backgroundColor = UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 0.3);
		levelLabel.text = "Level \(level)";
		levelLabel.font = UIFont(name:"GillSans-UltraBold", size: 15.0);
		levelLabel.textAlignment = NSTextAlignment.center;
		levelLabel.textColor = UIColor.yellow;
		
		livesLabel = UILabel(frame: CGRect(x: width - width/3, y: 0, width: width/3, height: height/16));
		livesLabel.backgroundColor = UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 0.3);
		livesLabel.text = "Lives: \(lives)";
		livesLabel.font = UIFont(name:"GillSans-UltraBold", size: 15.0);
		livesLabel.textAlignment = NSTextAlignment.center;
		livesLabel.textColor = UIColor.white;
		
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
		
		player.position = CGPoint(x: size.width / 2, y: size.height / 8);
		player.physicsBody = SKPhysicsBody(rectangleOf: player.size);
		player.physicsBody?.affectedByGravity = false;
		player.physicsBody?.categoryBitMask = GamePiece.Player;
		player.physicsBody?.contactTestBitMask = GamePiece.Enemy;
		player.physicsBody?.isDynamic = false;
		
		ammoSpawnTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(SpawnAmmo), userInfo: nil, repeats: true);
		enemySpawnTimer = Timer.scheduledTimer(timeInterval: spawnRate, target: self, selector: #selector(SpawnEnemies), userInfo: nil, repeats: true);
		
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
		
		view.addSubview(scoreLabel);
		view.addSubview(levelLabel);
		view.addSubview(livesLabel);
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
		Ammo.removeFromParent();
		Enemy.texture = SKTexture(imageNamed: "explosion.png");
		
		let fade = SKAction.fadeAlpha(to: 0, duration: 0.5);
		Enemy.run(fade);
		
		enemy = Enemy;
		enemy.physicsBody?.categoryBitMask = 0;
		
		Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(EnemyDestroyed), userInfo: nil, repeats: false);
		
		score += 1;
		scoreLabel.text = "Score: \(score)";
		
		if(score == levelIncrease)
		{
			enemySpawnTimer.invalidate();
			spawnRate = spawnRate * 0.8;
			enemySpawnTimer = Timer.scheduledTimer(timeInterval: spawnRate, target: self, selector: #selector(SpawnEnemies), userInfo: nil, repeats: true);
			
			levelIncrease = levelIncrease + 10;
			
			level += 1;
			levelLabel.text = "Level \(level)";
		}
	}
	
	func CollisionWithPlayer(_ Enemy:SKSpriteNode, Player: SKSpriteNode)
	{
		player.physicsBody?.categoryBitMask = 0;
		
		lives -= 1;
		livesLabel.text = "Lives: \(lives)";

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
			
			let uniquePlayerId: String = String(year) + String(month) + String(day) + String(hour);
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
		player.physicsBody?.categoryBitMask = GamePiece.Player;
	}
	
	func EnemyDestroyed()
	{
		enemy.removeFromParent();
	}
	
	func PlayerDestroyed()
	{
		player.removeFromParent();
		enemy.removeFromParent();
		
		livesLabel.removeFromSuperview();
		scoreLabel.removeFromSuperview();
		
		let gameOverView = GameOverView();
		gameOverView.viewController = self.viewController;
		view?.presentScene(gameOverView);
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
		let height = size.height;
		
		Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint)), y: height);
		Enemy.physicsBody = SKPhysicsBody(rectangleOf: Enemy.size);
		Enemy.physicsBody?.categoryBitMask = GamePiece.Enemy;
		Enemy.physicsBody?.contactTestBitMask = GamePiece.Ammo;
		Enemy.physicsBody?.affectedByGravity = false;
		Enemy.physicsBody?.isDynamic = true;
		
		let linearPath1 = SKAction.moveTo(y: height - height/3, duration: 1.0);
		let linearPath2 = SKAction.moveTo(y: height/3, duration: 1.0);
		
		let highLevelPath1 = SKAction.moveTo(y: height - height/4, duration: 0.5);
		let highLevelPath2 = SKAction.moveTo(y: height/2, duration: 0.5);
		let highLevelPath3 = SKAction.moveTo(y: height/6, duration: 0.5);
		
		let circle = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 50, height: 50), cornerRadius: 50);
		let circlePath = SKAction.follow(circle.cgPath, asOffset: true, orientToPath: false, duration: 0.25);
		
		let offScreenPathNormal = SKAction.moveTo(y: -70, duration: 2.0);
		let offScreenPathHigherLevel = SKAction.moveTo(y: -70, duration: 0.5);
		
		let actionDone = SKAction.removeFromParent();
		
		if(score < 10)
		{
			Enemy.run(SKAction.sequence([offScreenPathNormal, actionDone]));
		}
		else if (score < 20)
		{
			Enemy.run(SKAction.sequence([linearPath1, circlePath, linearPath2, circlePath, offScreenPathHigherLevel, actionDone]));
		}
		else if (score < levelIncrease)
		{
			Enemy.run(SKAction.sequence([highLevelPath1, circlePath, highLevelPath2, circlePath, highLevelPath3, circlePath, offScreenPathHigherLevel, actionDone]));
		}
		
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
