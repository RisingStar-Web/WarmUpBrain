//
//  MathFormulaPrototipe.swift
//  WarmUpBrain
//
//  Created by Yulia Lopatina on 23.06.2019.
//  Copyright © 2019 Yulia Lopatina. All rights reserved.
//

final class MathFormulaPrototipe {
  let number: Int
  let type: FormulaType

  init(number: Int = 0, type: FormulaType = .number) {
    self.number = number
    self.type = type
  }

  enum FormulaType: Int {
    case plus
    case minus
    case multiply
    case divide
    case number
  }
}
