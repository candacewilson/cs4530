//
//  GameOverView.swift
//  Project F - Vertical Shooter - Candace Wilson
//
//  Created by Candace Wilson on 4/5/17.
//  Copyright © 2017 Candace Wilson. All rights reserved.
//

import Foundation;
import SpriteKit;

class GameOverView : SKScene
{
	var HighScores : [String : Int] = [:];
	var ScoreLabel : UILabel!;
	var GameOverLabel : UILabel!;
	var HighScoresButton : UIButton!;
	var RestartButton : UIButton!;
	var MainMenuButton : UIButton!;
	var BackgroundImage: UIImageView = UIImageView();
	var PlayerName: UITextField = UITextField();
	var viewController: UIViewController?
	
	override func didMove(to view: SKView)
	{
		let width = view.frame.size.width;
		let height = view.frame.size.height;
		
		let background: UIImage = UIImage(named: "space.png")!;
		BackgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height));
		BackgroundImage.contentMode = .scaleAspectFill;
		BackgroundImage.image = background;
		
		GameOverLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		GameOverLabel.center = CGPoint(x: width/2, y: width/5);
		GameOverLabel.text = "GAME OVER";
		GameOverLabel.textAlignment = NSTextAlignment.center;
		GameOverLabel.font = UIFont(name:"GillSans-UltraBold", size: 40.0);
		GameOverLabel.textColor = UIColor.red;
		
		let ScoreDefault = UserDefaults.standard;
		let Score = ScoreDefault.value(forKey: "Score") as! NSInteger;
		
		let HighScoreDefault = UserDefaults.standard;
		
		if (HighScoreDefault.dictionary(forKey: "HighScore") != nil)
		{
			HighScores = (HighScoreDefault.dictionary(forKey: "HighScore") as? [String : Int])!;
		}

		let UniquePlayerId = UserDefaults.standard;
		let uniquePlayerId = (UniquePlayerId.value(forKey: "UniquePlayerId") as? String)!;
		
		if (HighScores.count == 0 || HighScores.keys.contains(uniquePlayerId))
		{
			HighScores.removeValue(forKey: uniquePlayerId);
			
			let popup = UIAlertController(title: "Congratulations!", message: "You placed in the top 5 scores!", preferredStyle: .alert);
			popup.addAction(UIAlertAction(title: "Enter", style: .default, handler: { alert -> Void in
				
				self.PlayerName = popup.textFields![0] as UITextField;
				
				if(!((self.PlayerName.text?.isEmpty)!))
				{
					self.HighScores[(self.PlayerName.text)!] = Score;
					HighScoreDefault.setValue(self.HighScores, forKey: "HighScore");
				}
				else
				{
					let errorAlert = UIAlertController(title: "Error", message: "Please enter a name", preferredStyle: .alert);
					errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { alert -> Void in
						self.viewController?.present(popup, animated: true, completion: nil);
					}))
					self.viewController?.present(errorAlert, animated: true, completion: nil);
				}
			}));
			
			popup.addTextField ( configurationHandler: { (textField) -> Void in
				textField.placeholder = "Enter your name";
			});
		
			let viewController = self.view?.window?.rootViewController;
			if (viewController?.presentedViewController == nil)
			{
				viewController?.present(popup, animated: true, completion: nil);
			}
		}
	
		ScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 60));
		ScoreLabel.center = CGPoint(x: width/2, y: height/3);
		ScoreLabel.text = "Score: \(Score)";
		ScoreLabel.textAlignment = NSTextAlignment.center;
		ScoreLabel.font = UIFont(name:"GillSans-UltraBold", size: 30.0);
		ScoreLabel.textColor = UIColor.orange;
		
		HighScoresButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		HighScoresButton.center = CGPoint(x: width/2, y: height - (height/4));
		HighScoresButton.setTitle("View High Scores", for: UIControlState());
		HighScoresButton.setTitleColor(UIColor.magenta, for: UIControlState());
		HighScoresButton.titleLabel!.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		HighScoresButton.addTarget(self, action: #selector(ViewHighScores), for: UIControlEvents.touchUpInside);
		
		RestartButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		RestartButton.center = CGPoint(x: width/2, y: height - (height/3) );
		RestartButton.setTitle("Restart Game", for: UIControlState());
		RestartButton.setTitleColor(UIColor.magenta, for: UIControlState());
		RestartButton.titleLabel!.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		RestartButton.addTarget(self, action: #selector(Restart), for: UIControlEvents.touchUpInside);
		
		MainMenuButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		MainMenuButton.center = CGPoint(x: width/2, y: height - (height/5) );
		MainMenuButton.setTitle("Return to Main Menu", for: UIControlState());
		MainMenuButton.setTitleColor(UIColor.magenta, for: UIControlState());
		MainMenuButton.titleLabel!.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		MainMenuButton.addTarget(self, action: #selector(ReturnToMainMenu), for: UIControlEvents.touchUpInside);
		
		view.addSubview(BackgroundImage);
		view.addSubview(GameOverLabel);
		view.addSubview(ScoreLabel);
		view.addSubview(HighScoresButton);
		view.addSubview(RestartButton);
		view.addSubview(MainMenuButton);
	}
	
	func ViewHighScores()
	{
		view?.presentScene(HighScoreView(), transition: SKTransition.crossFade(withDuration: 0.3));
		BackgroundImage.removeFromSuperview();
		HighScoresButton.removeFromSuperview();
		RestartButton.removeFromSuperview();
		MainMenuButton.removeFromSuperview();
		ScoreLabel.removeFromSuperview();
		GameOverLabel.removeFromSuperview();
	}

	func Restart()
	{
		view?.presentScene(GameView(), transition: SKTransition.crossFade(withDuration: 0.3));
		BackgroundImage.removeFromSuperview();
		HighScoresButton.removeFromSuperview();
		RestartButton.removeFromSuperview();
		MainMenuButton.removeFromSuperview();
		ScoreLabel.removeFromSuperview();
		GameOverLabel.removeFromSuperview();
	}
	
	func ReturnToMainMenu()
	{
		view?.presentScene(MainMenuView(), transition: SKTransition.crossFade(withDuration: 0.3));
		BackgroundImage.removeFromSuperview();
		HighScoresButton.removeFromSuperview();
		RestartButton.removeFromSuperview();
		MainMenuButton.removeFromSuperview();
		ScoreLabel.removeFromSuperview();
		GameOverLabel.removeFromSuperview();
	}
	
}
