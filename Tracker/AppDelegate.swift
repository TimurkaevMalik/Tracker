//
//  AppDelegate.swift
//  Tracker
//
//  Created by Malik Timurkaev on 04.04.2024.
//

import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "068699ac-1bbd-4921-8ae5-b0799af4f23b") else {
            return true
        }
        
        YMMYandexMetrica.activate(with: configuration)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let sceneConfiguration = UISceneConfiguration(name: "Main", sessionRole: connectingSceneSession.role)
        
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataModel")
        
        container.loadPersistentStores { description, error in
            
            if let error = error as NSError? {
                
                assertionFailure("catched error while loading Persistent Stores. Description: \(error)")
            }
        }
        
        return container
    }()
    
    func saveContext(){
        
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            
            do {
                try context.save()
            } catch let error as NSError {
                
                assertionFailure("\(error)")
                context.rollback()
            }
        }
    }
}

