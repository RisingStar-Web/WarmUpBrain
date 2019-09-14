//
//  ScoreViewPrototipe.swift
//  WarmUpBrain
//
//  Created by Yulia Lopatina on 23.06.2019.
//  Copyright © 2019 Yulia Lopatina. All rights reserved.
//

import CoreData
import Foundation

final class ScoreViewPrototipe {
  /// Level of formula

  /// Manager for core data
  private var coreDataManager: CoreDataManager?

  /// Context for CoreData
  public var context: NSManagedObjectContext?

  // Best score user for all trainings
  public var userBestScore: Int = 0

  /// Settings for level
  private var maxNumbersInFormula: Int = 3
  private var maxCountInNumber: Int = 100
  private var maxFormulaType: Int = 2
  private var maxMultiplyNumber: Int = 10

  /// Strong level for training
  public var trainingDifficalty: Difficalty = .easy {
    didSet {
      switch trainingDifficalty {
      case .middle:
        maxNumbersInFormula = 5
        maxCountInNumber = 100
        maxFormulaType = 3
        maxMultiplyNumber = 30
      case .hard:
        maxNumbersInFormula = 7
        maxCountInNumber = 100
        maxFormulaType = 4
        maxMultiplyNumber = 30
      default:
        maxNumbersInFormula = 3
        maxCountInNumber = 100
        maxFormulaType = 2
        maxMultiplyNumber = 10
      }
    }
  }

  /// Full training score
  private var fullScore: Int = 0 {
    didSet {
      guard let trainingScore = self.handleTrainingScore else {
        return
      }
      trainingScore(fullScore, oldValue < fullScore)
    }
  }

  /// Active formula for training
  private var formulaModels: [MathFormulaPrototipe] = [] {
    didSet {
      guard let trainingFormula = self.handleTrainingFormula else {
        return
      }
      var resultFormula = ""
      for item in formulaModels {
        switch item.type {
        case .plus:
          resultFormula.append(" + ")
        case .minus:
          resultFormula.append(" - ")
        case .multiply:
          resultFormula.append(" * ")
        case .divide:
          resultFormula.append(" / ")
        default:
          resultFormula.append("\(item.number)")
        }
      }
      formulaFormat = resultFormula
      trainingFormula(resultFormula)
    }
  }

  /// Format string formula
  private var formulaFormat: String = ""

  /// Bind formula with training controller
  var handleTrainingFormula: ((_ formula: String) -> Void)?

  /// Bind all score with training controller
  var handleTrainingScore: ((_ score: Int, _ success: Bool) -> Void)?

  /// Init core data
  func initCoreDataManager(context: NSManagedObjectContext) {
    coreDataManager = CoreDataManager(context: context)
    userBestScore = coreDataManager!.chooseScore()
  }

  /// Generate next formula
  func nextFormula() {
    var result: [MathFormulaPrototipe] = []
    var lastFormulaType: MathFormulaPrototipe.FormulaType = .number
    var isNumber = true
    for _ in 1 ... maxNumbersInFormula {
      if isNumber {
        // Generate number for formula
        var number = arc4random_uniform(UInt32(maxCountInNumber))
        // Minify number if last formula type is multiply or divide
        if lastFormulaType == .multiply || lastFormulaType == .divide {
          number = arc4random_uniform(UInt32(maxMultiplyNumber))
        }
        result.append(MathFormulaPrototipe(number: Int(number)))
      } else {
        // Generate arithmetic sings for formula
        let random = Int(arc4random_uniform(UInt32(maxFormulaType)))
        if let type = MathFormulaPrototipe.FormulaType(rawValue: random) {
          result.append(MathFormulaPrototipe(type: type))
          lastFormulaType = type
        }
      }
      isNumber = !isNumber
    }
    formulaModels = result
  }

  /// Check equals result and answer
  func checkAnswer(_ number: Double) {
    let mathExpression = NSExpression(format: formulaFormat)
    if let mathValue = mathExpression.expressionValue(with: nil, context: nil) as? Double {
      var result = Int(mathValue)
      // Revent negative sign
      if result < 0 {
        result *= -1
      }
      if mathValue == number {
        fullScore += Int(result)

        // Update best user score
        if fullScore > userBestScore {
          if let dataManager = self.coreDataManager {
            dataManager.newScore(score: fullScore)

            // Set result to user best score
            userBestScore = fullScore
          }
        }
      } else {
        fullScore -= Int(result)
      }
    }
  }
}

enum Difficalty {
    case easy
    case middle
    case hard
}
