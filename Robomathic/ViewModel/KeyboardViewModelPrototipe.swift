//
//  KeyboardViewModelPrototipe.swift
//  WarmUpBrain
//
//  Created by Yulia Lopatina on 22.06.2019.
//  Copyright © 2019 Yulia Lopatina. All rights reserved.
//

import UIKit

final class KeyboardViewModelPrototipe {
  /// Keys for keyboard list
  public let keys: [ButtonModelPrototipe]

  /// Actual user number
  private var userNumber: String {
    didSet {
      guard let numberBind = self.handleDidChangeNumber else {
        return
      }
      numberBind(userNumber)
    }
  }

  /// Bind label user number
  var handleDidChangeNumber: ((_ userNumber: String) -> Void)?

  init() {
    var createKeys: [ButtonModelPrototipe] = []
    for number in 0 ... 9 {
      createKeys.append(ButtonModelPrototipe(name: "\(number)", type: .number))
    }
    createKeys.append(ButtonModelPrototipe(name: "-", type: .number))

    // Button cancel
    let keyCancelText = NSLocalizedString("Clean", comment: "Keyboard clean button")
    let keyCancel = ButtonModelPrototipe(name: keyCancelText, type: .clean, imageName: "ic_clean")
    createKeys.append(keyCancel)

    // Init variables
    keys = createKeys
    userNumber = ""
  }

  /// Touch to button
  func touchButton(_ keyModel: ButtonModelPrototipe) {
    switch keyModel.buttonType {
    // Clean last character in user numbers
    case .clean:
      if userNumber.count > 1 {
        userNumber.removeLast()
      } else {
        userNumber = ""
      }
    // Write number in user numbers
    default:
      userNumber += "\(keyModel.buttonName)"
    }
  }
    
    func resetNumber() {
        userNumber = ""
    }
}
