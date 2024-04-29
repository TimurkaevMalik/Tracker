//
//  TabBarControler.swift
//  Tracker
//
//  Created by Malik Timurkaev on 04.04.2024.
//

import UIKit


final class TabBarControler: UITabBarController {
    
    func makeTabBarTopBorderLine(){
        
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor(red:0.0/255.0, green:0.0/255.0, blue:0.0/255.0, alpha:0.2).cgColor
        self.tabBar.layer.masksToBounds = true
    }
    
    func addTabBarItems(){
        
        let navigationController = UINavigationController()
        
        let trackerViewController = TrackerViewController()
        let statisticViewController = StatisticViewController()
        
        navigationController.viewControllers = [trackerViewController]
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackerBarItem"),
            selectedImage: nil)
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatisticBarItem"),
            selectedImage: nil)
        
        self.viewControllers = [
            navigationController,
            statisticViewController,
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTabBarTopBorderLine()
        addTabBarItems()
    }
}
