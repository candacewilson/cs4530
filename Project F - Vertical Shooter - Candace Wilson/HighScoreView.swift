//
//  HighScoreView.swift
//  Project F - Vertical Shooter - Candace Wilson
//
//  Created by Candace Wilson on 4/5/17.
//  Copyright © 2017 Candace Wilson. All rights reserved.
//

import Foundation;
import SpriteKit;

class HighScoreView : SKScene
{
	var MainMenuButton : UIButton!;
	var HighScores : [String : Int] = [:];
	var HighScoreLabel : UILabel!;
	var BackgroundImage: UIImageView = UIImageView();
	
	override func didMove(to view: SKView)
	{
		let width = view.frame.size.width;
		let height = view.frame.size.height;
		
		let background: UIImage = UIImage(named: "space.png")!;
		BackgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height));
		BackgroundImage.contentMode = .scaleAspectFill;
		BackgroundImage.image = background;
		
		let HighScoreDefault = UserDefaults.standard;
		var listOfHighScores: String = "";
		
		HighScoreLabel = UILabel(frame: CGRect(x: 0, y: height/5, width: width, height: height/2));
		HighScoreLabel.textAlignment = NSTextAlignment.center;
		HighScoreLabel.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		HighScoreLabel.numberOfLines = 0;
		HighScoreLabel.textColor = UIColor.green;
		
		if (HighScoreDefault.dictionary(forKey: "HighScore") != nil)
		{
			HighScores = (HighScoreDefault.dictionary(forKey: "HighScore") as? [String : Int])!;
			
			for (name,score) in (Array(HighScores).sorted {$0.1 > $1.1})
			{
				listOfHighScores = listOfHighScores + "\(name): \(score)\n";
			}
			
			HighScoreLabel.text = "High Scores\n\n\n\(listOfHighScores)";
		}
		else
		{
			HighScores = [:];
		}
		
		MainMenuButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height + (height/2)));
		MainMenuButton.setTitle("Return to Main Menu", for: UIControlState());
		MainMenuButton.setTitleColor(UIColor.magenta, for: UIControlState());
		MainMenuButton.titleLabel!.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		MainMenuButton.titleLabel?.textAlignment = NSTextAlignment.center;
		MainMenuButton.addTarget(self, action: #selector(ReturnToMainMenu), for: UIControlEvents.touchUpInside);
		
		view.addSubview(BackgroundImage);
		view.addSubview(HighScoreLabel);
		view.addSubview(MainMenuButton);
	}
	
	func ReturnToMainMenu()
	{
		view?.presentScene(MainMenuView(), transition: SKTransition.crossFade(withDuration: 0.3));
		BackgroundImage.removeFromSuperview();
		MainMenuButton.removeFromSuperview();
		HighScoreLabel.removeFromSuperview();
	}
}
