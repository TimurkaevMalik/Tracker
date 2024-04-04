//
//  TabBarControler.swift
//  Tracker
//
//  Created by Malik Timurkaev on 04.04.2024.
//

import UIKit


final class TabBarControler: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackerViewController = TrackerViewController()
        let statisticViewController = StatisticViewController()
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackerBarItem"),
            selectedImage: nil)
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatisticBarItem"),
            selectedImage: nil)
        
        self.viewControllers = [
            trackerViewController,
            statisticViewController
        ]
    }
}
