//
//  GameViewController.swift
//  Project F - Vertical Shooter - Candace Wilson
//
//  Created by Candace Wilson on 4/5/17.
//  Copyright © 2017 Candace Wilson. All rights reserved.
//

import UIKit;
import SpriteKit;

extension SKNode
{
	class func unarchiveFromFile(_ file : NSString) -> SKNode?
	{
		if let path = Bundle.main.path(forResource: file as String, ofType: "sks")
		{
			let sceneData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe);
			let archiver = NSKeyedUnarchiver(forReadingWith: sceneData);
			
			archiver.setClass(classForKeyedUnarchiver(), forClassName: "SKScene");
			
			let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameView;
			archiver.finishDecoding();
			
			return scene;
		}
		else
		{
			return nil;
		}
	}
}

class GameViewController: UIViewController
{
	var StartGameButton : UIButton!;
	var HighScoresButton : UIButton!;
	var TitleLabel : UILabel!;
	var BackgroundImage: UIImageView = UIImageView();
	
	override func viewDidLoad()
	{
		super.viewDidLoad();
		
		let width = view.frame.size.width;
		let height = view.frame.size.height;
		
		let background: UIImage = UIImage(named: "space.png")!;
		BackgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height));
		BackgroundImage.contentMode = .scaleAspectFill;
		BackgroundImage.image = background;
		
		TitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		TitleLabel.center = CGPoint(x: width/1.75, y: width/3);
		TitleLabel.text = "SPACE PUP";
		TitleLabel.font = UIFont(name:"GillSans-UltraBold", size: 40.0);
		TitleLabel.textColor = UIColor.yellow;
		
		StartGameButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		StartGameButton.center = CGPoint(x: width/2, y: width);
		StartGameButton.setTitle("Start Game", for: UIControlState());
		StartGameButton.setTitleColor(UIColor.cyan, for: UIControlState());
		StartGameButton.titleLabel!.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		StartGameButton.addTarget(self, action: #selector(StartGame), for: UIControlEvents.touchUpInside);
		
		HighScoresButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		HighScoresButton.center = CGPoint(x: width/2, y: width + width/8);
		HighScoresButton.setTitle("High Scores", for: UIControlState());
		HighScoresButton.setTitleColor(UIColor.cyan, for: UIControlState());
		HighScoresButton.titleLabel!.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		HighScoresButton.addTarget(self, action: #selector(HighScores), for: UIControlEvents.touchUpInside);
		
		view.addSubview(BackgroundImage);
		view.addSubview(TitleLabel);
		view.addSubview(StartGameButton);
		view.addSubview(HighScoresButton);
	}
	
	func StartGame()
	{
		BackgroundImage.removeFromSuperview();
		TitleLabel.removeFromSuperview();
		StartGameButton.removeFromSuperview();
		HighScoresButton.removeFromSuperview();
		
		let skView = view as! SKView;
		let gameView = GameView();
		gameView.viewController = self;
		skView.presentScene(gameView, transition: SKTransition.crossFade(withDuration: 0.3));
	}
	
	func HighScores()
	{
		BackgroundImage.removeFromSuperview();
		TitleLabel.removeFromSuperview();
		StartGameButton.removeFromSuperview();
		HighScoresButton.removeFromSuperview();
		
		let skView = view as! SKView;
		skView.presentScene(HighScoreView(), transition: SKTransition.crossFade(withDuration: 0.3));
	}
	
	override var shouldAutorotate : Bool
	{
		return true;
	}
	
	override var supportedInterfaceOrientations : UIInterfaceOrientationMask
	{
		if UIDevice.current.userInterfaceIdiom == .phone
		{
			return UIInterfaceOrientationMask.allButUpsideDown;
		}
		else
		{
			return UIInterfaceOrientationMask.all;
		}
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning();
	}
	
	override var prefersStatusBarHidden : Bool
	{
		return true;
	}
}
