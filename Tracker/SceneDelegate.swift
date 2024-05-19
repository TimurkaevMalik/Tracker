//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Malik Timurkaev on 04.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard 
            let scene = (scene as? UIWindowScene),
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
        
        window = UIWindow(windowScene: scene)
        
        if appDelegate.wasOnboardinShown == false {
            window?.rootViewController = OnboardingViewController()
        } else {
            window?.rootViewController = TabBarControler()
        }
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

