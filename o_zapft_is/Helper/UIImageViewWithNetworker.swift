//
//  UIImageViewWithNetworker.swift
//  o_zapft_is
//
//  Created by Jeanette Müller on 16.12.23.
//

import UIKit
import Combine

class UIImageViewWithNetworker: UIImageView {
    
    var cancellables: Set<AnyCancellable> = []
    
    private var downloadUrl: URL?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        NotificationCenter.default
            .publisher(for: .NetworkerTransferDidFinished)
            .sink { notification in
                
                if let task = notification.object as? URLSessionDownloadTask {
                    if let requestUrl = task.originalRequest?.url, requestUrl == self.downloadUrl {
                        
                        self.showDownloadedImage()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func showImage(from: URL) {
        
        self.downloadUrl = from
        
        let filePath = Networker.getLocalPathFor(from.absoluteString)
        
        if FileManager.default.fileExists(atPath: filePath){
            self.showDownloadedImage()
        }else{
            _ = Networker.shared.performDownloadTask(from, withDescription: "download Image")
        }
    }
    
    func showDownloadedImage() {
        if let url = self.downloadUrl {
            DispatchQueue.global(qos: .background).async {
                
                let filePath = Networker.getLocalPathFor(url.absoluteString)
                let image = UIImage(contentsOfFile: filePath)
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
