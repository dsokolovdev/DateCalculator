//
//  SceneDelegate.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 10.10.2025.
//
//  Description:
//  Manages the app’s main window and initial scene setup.
//  Initializes shared models, view models, and the root navigation stack.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // MARK: - Scene Lifecycle
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // MARK: Setup Root Dependencies
        // Create a shared SettingsModel instance.
        let settingsModel = SettingsModel()
        
        // Create ViewModel with a reference to the same SettingsModel.
        let viewModel = DateCalculatorViewModel(settingsModel: settingsModel)
        
        // Initialize the main screen.
        let dateCalculatorVC = DateCalculatorViewController(viewModel: viewModel)
        
        // Embed inside UINavigationController.
        let navController = UINavigationController(rootViewController: dateCalculatorVC)
        
        //        // Optional: Custom global background
        //        let backgroundColor = UIColor { trait in
        //            trait.userInterfaceStyle == .dark
        //            ? UIColor(red: 0.13, green: 0.16, blue: 0.20, alpha: 1.0) // 🌙 #222A33
        //            : UIColor(red: 0.98, green: 0.99, blue: 1.00, alpha: 1.0) // ☀️ #FAFDFF
        //        }
        //        navController.view.backgroundColor = backgroundColor
        //        dateCalculatorVC.view.backgroundColor = backgroundColor
        //        UINavigationBar.appearance().barTintColor = backgroundColor
        //        UINavigationBar.appearance().backgroundColor = backgroundColor
        
        // Configure and show window.
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    // MARK: - Scene State Changes
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is released by the system.
        // This occurs shortly after entering background or when discarded.
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene becomes active again.
        // Restart paused tasks or refresh UI if necessary.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene is about to move from active to inactive.
        // Useful for handling temporary interruptions (e.g., phone calls).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from background to foreground.
        // Undo changes made when entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from foreground to background.
        // Save data, release resources, and store enough state for restoration.
    }
}
