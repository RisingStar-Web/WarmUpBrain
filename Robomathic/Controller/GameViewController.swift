//
//  GameViewController.swift
//  WarmUpBrain
//
//  Created by Yulia Lopatina on 22.06.2019.
//  Copyright © 2019 Yulia Lopatina. All rights reserved.
//

import CoreData
import UIKit

final class GameViewController: UIViewController {
  /// Training level for formula
  public var trainingLevel: Difficalty?

  /// Delay for cell's animation
  private var delayLastAnimationCell: Double = 0

  /// View model for keyboard
  private let keyboardViewModel = KeyboardViewModelPrototipe()

  /// View model for score training
  private let scoreViewModel = ScoreViewPrototipe()

  /// UI's
  @IBOutlet var formulaUILabel: UILabel!
  @IBOutlet var userNumberUILabel: UILabel!
  @IBOutlet var userScoreUILabel: UILabel!
  @IBOutlet var answerBackgroundUIView: UIView!

  /// Stop game and back to root controller
  @IBAction func buttonEndGame(_: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }

  override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
    guard let identifier = segue.identifier else {
      return
    }

    // Send best score to end controller
    if identifier == "EndTraining", let endController = segue.destination as? GameOverViewController {
      endController.bestScore = scoreViewModel.userBestScore
    }
  }
    @IBAction func onAnswerButton(_ sender: Any) {
        guard let text = userNumberUILabel.text, let result = Double(text) else {
            return
        }
        self.scoreViewModel.checkAnswer(result)
        self.scoreViewModel.nextFormula()
        self.keyboardViewModel.resetNumber()
    }

  /// Configure controller
  private func configure() {
    // Bind number label with keyboard
    keyboardViewModel.handleDidChangeNumber = { number in
      self.userNumberUILabel.text = number
    }

    // Bind formula
    scoreViewModel.handleTrainingFormula = { formula in
      // Animate label and set result
      self.formulaUILabel.animateFadeOut(duration: 0.3, completion: {
        self.formulaUILabel.text = formula
        self.formulaUILabel.animateFadeIn(duration: 0.3)
      })
    }

    // Bind score
    scoreViewModel.handleTrainingScore = { score, success in
      // Animate label and set result
      self.userScoreUILabel.animateFadeOut(duration: 0.5, completion: {
        self.userScoreUILabel.text = "\(score)"
        self.userScoreUILabel.animateFadeIn(duration: 0.5)
      })

      // Indicate success answer or not
      let colorStart = self.answerBackgroundUIView.backgroundColor ?? UIColor.white
      let colorSuccess = UIColor(displayP3Red: 198/255,
                                 green: 221/255,
                                 blue: 63/255,
                                 alpha: 1)
      let colorError = UIColor.red
      if success {
        self.answerBackgroundUIView.animateBackgroundColor(colorStart: colorStart,
                                                           colorEnd: colorSuccess,
                                                           duration: 0.5)
      } else {
        self.answerBackgroundUIView.animateBackgroundColor(colorStart: colorStart, colorEnd: colorError, duration: 0.5)
      }

      if score < 0 {
        self.performSegue(withIdentifier: "EndTraining", sender: self)
      }
    }

    // Set level and create new formula
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      let context = appDelegate.persistentContainer.viewContext

      scoreViewModel.trainingDifficalty = trainingLevel ?? .easy
      scoreViewModel.initCoreDataManager(context: context)
      scoreViewModel.nextFormula()
    }
  }
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  /// Count of collection view
  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return keyboardViewModel.keys.count
  }

  /// Creating cells collection view
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let keyModel = keyboardViewModel.keys[indexPath.row]

    if keyModel.buttonType == .number {
      // If button is number
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyboardNumberViewCell", for: indexPath)

      if let keyboardCell = cell as? KeyboardNumberViewCell {
        keyboardCell.labelNumber.text = keyModel.buttonName
      }

      // Animate cell
      cell.animateFadeInDown(duration: 0.2, delay: delayLastAnimationCell)
      delayLastAnimationCell += 0.1

      return cell
    } else {
      // If button is function
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyboardFuncViewCell", for: indexPath)

      if let keyboardCell = cell as? KeyboardFuncViewCell {
        keyboardCell.labelName.text = keyModel.buttonName
        if let imageName: String = keyModel.imageName {
          keyboardCell.imageIcon.image = UIImage(named: imageName)
        }

        // Animate cell
        keyboardCell.animateFadeInDown(duration: 0.2, delay: delayLastAnimationCell)
        delayLastAnimationCell += 0.1
      }

      return cell
    }
  }

  /// Touch to collection cell
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let keyModel = keyboardViewModel.keys[indexPath.row]

    // Animate cell
    if let cell = collectionView.cellForItem(at: indexPath) {
      cell.animateScaleOut(duration: 0.2, completion: {
        cell.animateScaleIn(duration: 0.2)
      })
    }

    keyboardViewModel.touchButton(keyModel)
  }

  /// Size collection view
  func collectionView(_ collectionView: UICollectionView,
                      layout _: UICollectionViewLayout,
                      sizeForItemAt _: IndexPath) -> CGSize {
    let bounds = collectionView.bounds
    let width = bounds.width / CGFloat(5) - CGFloat(5)
    return CGSize(width: width, height: width)
  }
}
