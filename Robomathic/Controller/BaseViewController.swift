//
//  ViewController.swift
//  WarmUpBrain
//
//  Created by Yulia Lopatina on 18.06.2019.
//  Copyright © 2019 Yulia Lopatina. All rights reserved.
//

import UIKit

final class BaseViewController: UIViewController {
  @IBOutlet var buttonLight: UIButton!
  @IBOutlet var buttonMiddle: UIButton!
  @IBOutlet var buttonHard: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    localizationButtons()
    animateStart()
  }

  override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    guard let trainingController = segue.destination as? GameViewController else {
      return
    }

    // Set level to training
    switch identifier {
    case "LevelMiddle":
      trainingController.trainingLevel = .middle
    case "LevelHard":
      trainingController.trainingLevel = .hard
    default:
      trainingController.trainingLevel = .easy
    }
  }

  /// Localization buttons
  private func localizationButtons() {
    // Text for light button
    if let attributedTitle = self.buttonLight.attributedTitle(for: .normal) {
      let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
      let title = NSLocalizedString("Ease", comment: "Button level training")
      mutableAttributedTitle.replaceCharacters(in: NSRange(location: 0,
                                                           length: mutableAttributedTitle.length),
                                               with: title)
      buttonLight.setAttributedTitle(mutableAttributedTitle, for: .normal)
    }

    // Text for middle button
    if let attributedTitle = self.buttonMiddle.attributedTitle(for: .normal) {
      let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
      let title = NSLocalizedString("Medium", comment: "Button level training")
      mutableAttributedTitle.replaceCharacters(in: NSRange(location: 0,
                                                           length: mutableAttributedTitle.length),
                                               with: title)
      buttonMiddle.setAttributedTitle(mutableAttributedTitle, for: .normal)
    }

    // Text for hard button
    if let attributedTitle = self.buttonHard.attributedTitle(for: .normal) {
      let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
      let title = NSLocalizedString("Hard", comment: "Button level training")
      mutableAttributedTitle.replaceCharacters(in: NSRange(location: 0,
                                                           length: mutableAttributedTitle.length),
                                               with: title)
      buttonHard.setAttributedTitle(mutableAttributedTitle, for: .normal)
    }
  }

  /// Start animate for level buttons
  private func animateStart() {
    buttonLight.animateFadeInDown(duration: 0.5, delay: 0)
    buttonMiddle.animateFadeInDown(duration: 0.5, delay: 0.3)
    buttonHard.animateFadeInDown(duration: 0.5, delay: 0.6)
  }
}
