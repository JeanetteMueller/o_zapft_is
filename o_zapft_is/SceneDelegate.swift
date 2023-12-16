//
//  SceneDelegate.swift
//  o_zapft_is
//
//  Created by Jeanette Müller on 14.12.23.
//

import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var coordinator: RootCoordinator?
    
    var networker = Networker()
    var storage = StorageManager.shared
    
    var cancellables: Set<AnyCancellable> = []
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let appWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
        appWindow.windowScene = windowScene
        
        let nc = UINavigationController()
        
        coordinator = RootCoordinator(nc)
        coordinator?.start()
        
        appWindow.rootViewController = nc
        appWindow.makeKeyAndVisible()
        
        window = appWindow
        
        
        self.updateAppearance()
        
    }
    
    func updateAppearance() {
        
        coordinator?.navigationController.navigationBar.tintColor = UIColor(named: "MainTintColor")
        
        UIView.appearance().tintColor = UIColor(named: "MainTintColor")
        
        UITableView.appearance().backgroundColor = UIColor(named: "MainBackgroundColor")
        UICollectionView.appearance().backgroundColor = UIColor(named: "MainBackgroundColor")
        UITableViewCell.appearance().backgroundColor = UIColor(named: "ItemBackgroundColor")
        UICollectionViewCell.appearance().backgroundColor = UIColor(named: "ItemBackgroundColor")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            
            if let url = URL(string: apiEndPoint) {
                _ = self.networker.performDownloadTask(url, withDescription: "Download all beers")
                
                NotificationCenter.default
                    .publisher(for: .NetworkerTransferDidFinished)
                    .sink { notification in
                        
                        if let task = notification.object as? URLSessionDownloadTask {
                            if let requestUrl = task.originalRequest?.url, requestUrl == url {
                                
                                StorageManager.shared.updateFromDownload()
                            }
                        }
                    }
                    .store(in: &self.cancellables)
                
            }
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

