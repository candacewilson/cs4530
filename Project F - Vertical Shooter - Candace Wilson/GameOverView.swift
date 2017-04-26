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
	var HighScoreLabel : UILabel!;
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
		GameOverLabel.center = CGPoint(x: width/1.85, y: width/3);
		GameOverLabel.text = "GAME OVER";
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
		let uniquePlayerId: String = (UniquePlayerId.value(forKey: "UniquePlayerId") as? String)!;
		
		var listOfHighScores: String = "";

		if(HighScores.keys.contains(uniquePlayerId) || HighScores.keys.count == 0)
		{
			let popup = UIAlertController(title: "Congratulations!", message: "You placed in the top 5 scores!", preferredStyle: UIAlertControllerStyle.alert);
			popup.addTextField { (textField : UITextField) -> Void in
				textField.placeholder = "Enter your name";
			};
			
			let enterButton = UIAlertAction(title: "Enter", style: UIAlertActionStyle.default, handler: { [weak popup] (action) -> Void in
				self.PlayerName = (popup?.textFields![0])!;
				self.HighScores[(self.PlayerName.text)!] = Score;
				self.HighScores.removeValue(forKey: uniquePlayerId);
				
				HighScoreDefault.setValue(self.HighScores, forKey: "HighScore");
				
				for(name, score) in (Array(self.HighScores).sorted {$0.1 > $1.1})
				{
					listOfHighScores = listOfHighScores + "\(name): \(score)\n";
				}
				
				self.HighScoreLabel.text = "High Score:\n\(listOfHighScores)";
			});
			
			popup.addAction(enterButton);
			
			self.viewController?.present(popup, animated: true, completion: nil)
		}
		
		ScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		ScoreLabel.center = CGPoint(x: width/1.5, y: height/3);
		ScoreLabel.text = "Score: \(Score)";
		ScoreLabel.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		ScoreLabel.textColor = UIColor.orange;
		
		HighScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 60));
		HighScoreLabel.center = CGPoint(x: width/1.5, y: height/2);
		HighScoreLabel.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		HighScoreLabel.numberOfLines = 0;
		HighScoreLabel.textColor = UIColor.green;
		
		HighScoresButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		HighScoresButton.center = CGPoint(x: width/2, y: width + width/2);
		HighScoresButton.setTitle("View High Scores", for: UIControlState());
		HighScoresButton.setTitleColor(UIColor.magenta, for: UIControlState());
		HighScoresButton.titleLabel!.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		HighScoresButton.addTarget(self, action: #selector(ViewHighScores), for: UIControlEvents.touchUpInside);
		
		RestartButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		RestartButton.center = CGPoint(x: width/2, y: height - (height/4) );
		RestartButton.setTitle("Restart Game", for: UIControlState());
		RestartButton.setTitleColor(UIColor.magenta, for: UIControlState());
		RestartButton.titleLabel!.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		RestartButton.addTarget(self, action: #selector(Restart), for: UIControlEvents.touchUpInside);
		
		MainMenuButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 30));
		MainMenuButton.center = CGPoint(x: width/2, y: height - (height/3) );
		MainMenuButton.setTitle("Return to Main Menu", for: UIControlState());
		MainMenuButton.setTitleColor(UIColor.magenta, for: UIControlState());
		MainMenuButton.titleLabel!.font = UIFont(name:"GillSans-UltraBold", size: 20.0);
		MainMenuButton.addTarget(self, action: #selector(ReturnToMainMenu), for: UIControlEvents.touchUpInside);
		
		view.addSubview(BackgroundImage);
		view.addSubview(GameOverLabel);
		view.addSubview(ScoreLabel);
		view.addSubview(HighScoreLabel);
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
		HighScoreLabel.removeFromSuperview();
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
		HighScoreLabel.removeFromSuperview();
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
		HighScoreLabel.removeFromSuperview();
		ScoreLabel.removeFromSuperview();
		GameOverLabel.removeFromSuperview();
	}
	
}
