//
//  CoreData.swift
//  WarmUpBrain
//
//  Created by Yulia Lopatina on 26.06.2019.
//  Copyright © 2019 Yulia Lopatina. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
  private let context: NSManagedObjectContext

  init(context: NSManagedObjectContext) {
    self.context = context
  }

  /// Update user best score
  func newScore(score: Int) {
    guard let entity = NSEntityDescription.entity(forEntityName: "Main", in: context) else { return }
    let main = NSManagedObject(entity: entity, insertInto: context)

    main.setValue(score, forKey: "bestScore")

    do {
      try context.save()
    } catch {
      print("Failed saving")
    }
  }

  /// Get user best score
  func chooseScore() -> Int {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Main")

    do {
      guard let selectObjects = try context.fetch(request) as? [NSManagedObject] else { return 0 }

      if let result = selectObjects.last, let chooseScore = result.value(forKey: "bestScore") as? Int {
        return chooseScore
      }
    } catch {
      print("Failed select score")
    }

    return 0
  }
}
