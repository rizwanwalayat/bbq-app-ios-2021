//
//  DataModal.swift
//  Aduro
//
//  Created by Macbook Pro on 24/02/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import Foundation
import CoreData

class DataModal {
    let context:NSManagedObjectContext
        
        init()
        {
            context = CoreDataManager.sharedInstance.managedObjectContext
        }
        
        //MARK: - save & delete video path and file
        
        func saveVideoPath (path: String, duration : String, size: String, rotationAngle: Double, thumbnail: NSData, isSlowMotion: Bool) {
//            let rifleScopeVideosCount = getSaveVideoPath().count
            let rifleScopeVideos = NotificaitionTable(context: context)
            rifleScopeVideos.uid=12
            CoreDataManager.sharedInstance.saveContext()
        }
}
