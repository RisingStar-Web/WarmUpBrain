//
//  GameOverViewController.swift
//  WarmUpBrain
//
//  Created by Yulia Lopatina on 25.06.2019.
//  Copyright © 2019 Yulia Lopatina. All rights reserved.
//

import UIKit

final class GameOverViewController: UIViewController {
  /// User best score
  public var bestScore: Int = 0

  /// UI's
  @IBOutlet var labelScore: UILabel!
  @IBOutlet var buttonMenu: UIButton!

  /// Button return to menu
  @IBAction func buttonMenu(sender _: UIButton) {
    if let navigation = self.navigationController {
      navigation.popToRootViewController(animated: true)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    labelScore.text = "\(bestScore)"
    localizationButton()
    animateStart()
  }

  /// Lozalization button menu
  private func localizationButton() {
    if let attributedTitle = self.buttonMenu.attributedTitle(for: .normal) {
      let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
      let title = NSLocalizedString("Menu", comment: "Button return menu")
      mutableAttributedTitle.replaceCharacters(in: NSRange(location: 0,
                                                           length: mutableAttributedTitle.length),
                                               with: title)
      buttonMenu.setAttributedTitle(mutableAttributedTitle, for: .normal)
    }
  }

  /// Start animations for elements
  private func animateStart() {
    labelScore.animateFadeInDown(duration: 0.4)
    buttonMenu.animateFadeInDown(duration: 0.4, delay: 0.3)
  }
}
