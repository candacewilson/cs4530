//
//  MainMenuView.swift
//  Project F - Vertical Shooter - Candace Wilson
//
//  Created by Candace Wilson on 4/5/17.
//  Copyright © 2017 Candace Wilson. All rights reserved.
//

import Foundation;
import SpriteKit;

class MainMenuView : SKScene
{
	var StartGameButton : UIButton!;
	var HighScoreButton : UIButton!;
	var TitleLabel : UILabel!;
	var BackgroundImage: UIImageView = UIImageView();
	
	override func didMove(to view: SKView)
	{
		let width = view.frame.size.width;
		let height = view.frame.size.height;
		
		let background: UIImage = UIImage(named: "space.png")!;
		BackgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height));
		BackgroundImage.contentMode = .scaleAspectFill;
		BackgroundImage.image = background;
		
		TitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height/2));
		TitleLabel.center = CGPoint(x: width/2, y: height/3);
		TitleLabel.text = "SPACE PUP";
		TitleLabel.textAlignment = NSTextAlignment.center;
		TitleLabel.font = UIFont(name:"GillSans-UltraBold", size: 40.0);
		TitleLabel.textColor = UIColor.yellow;
		
		StartGameButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		StartGameButton.center = CGPoint(x: width/2, y: width);
		StartGameButton.setTitle("Start Game", for: UIControlState());
		StartGameButton.setTitleColor(UIColor.cyan, for: UIControlState());
		StartGameButton.titleLabel!.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		StartGameButton.addTarget(self, action: #selector(StartGame), for: UIControlEvents.touchUpInside);
		
		HighScoreButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		HighScoreButton.center = CGPoint(x: width/2, y: width + width/8);
		HighScoreButton.setTitle("High Scores", for: UIControlState());
		HighScoreButton.setTitleColor(UIColor.cyan, for: UIControlState());
		HighScoreButton.titleLabel!.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		HighScoreButton.addTarget(self, action: #selector(HighScores), for: UIControlEvents.touchUpInside);
		
		view.addSubview(BackgroundImage);
		view.addSubview(TitleLabel);
		view.addSubview(StartGameButton);
		view.addSubview(HighScoreButton);
	}
	
	func StartGame()
	{
		BackgroundImage.removeFromSuperview();
		TitleLabel.removeFromSuperview();
		StartGameButton.removeFromSuperview();
		HighScoreButton.removeFromSuperview();
		
		view?.presentScene(GameView(), transition: SKTransition.crossFade(withDuration: 0.3));
	}
	
	func HighScores()
	{
		BackgroundImage.removeFromSuperview();
		TitleLabel.removeFromSuperview();
		StartGameButton.removeFromSuperview();
		HighScoreButton.removeFromSuperview();
		
		view?.presentScene(HighScoreView(), transition: SKTransition.crossFade(withDuration: 0.3));
	}
}
