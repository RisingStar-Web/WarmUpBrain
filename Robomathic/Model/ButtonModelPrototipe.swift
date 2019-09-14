//
//  ButtonModelPrototipe.swift
//  WarmUpBrain
//
//  Created by Yulia Lopatina on 22.06.2019.
//  Copyright © 2019 Yulia Lopatina. All rights reserved.
//

final class ButtonModelPrototipe {
  let buttonName: String
  let buttonType: KeyType
  let imageName: String?

  init(name: String, type: KeyType, imageName: String? = nil) {
    buttonName = name
    buttonType = type
    self.imageName = imageName
  }

  enum KeyType {
    case number
    case clean
  }
}
