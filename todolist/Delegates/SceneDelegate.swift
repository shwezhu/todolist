//
//  SceneDelegate.swift
//  todolist
//
//  Created by David Zhu on 2024-07-03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func sceneWillEnterForeground(_ scene: UIScene) {
        NotificationManager.clearBadges()
        print("aaa")
    }
}
