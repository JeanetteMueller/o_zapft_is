//
//  Networker.swift
//  Ozapftis
//
//  Created by Jeanette Müller on 14.12.23.
//

import Foundation
import Combine


extension Notification.Name {
    static let NetworkerTransferDidStart            = Notification.Name("NetworkerTransferDidStart")
    static let NetworkerTransferDidUpdate           = Notification.Name("NetworkerTransferDidUpdate")
    static let NetworkerTransferDidFinished         = Notification.Name("NetworkerTransferDidFinished")
    static let NetworkerTransferDidFailed           = Notification.Name("NetworkerTransferDidFailed")
    
    static let NetworkerTransferNeedsCredentials    = Notification.Name("NetworkerTransferNeedsCredentials")
}

class Networker: NSObject {
    
    var runningTasks = [URLSessionTask]()
    var taskToResume: URLSessionTask?
    
    let transferDidStartPublisher = NotificationCenter.Publisher(center: .default, name: .NetworkerTransferDidStart, object: nil)
    
    
    lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        configuration.isDiscretionary = true
        configuration.sessionSendsLaunchEvents = true
        
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        //        var defaultHeaders = [AnyHashable: Any]()
        //        defaultHeaders["User-Agent"] = UserAgentHelper.userAgent()
        //        configuration.httpAdditionalHeaders = defaultHeaders
        
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    lazy var backgroundUrlSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "de.themaverick.o-zapft-is")
        
        configuration.isDiscretionary = false
        configuration.sessionSendsLaunchEvents = true
        
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
//        var defaultHeaders = [AnyHashable: Any]()
//        defaultHeaders["User-Agent"] = UserAgentHelper.userAgent()
//        configuration.httpAdditionalHeaders = defaultHeaders
        
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    func performDownloadTask(_ url: URL, withDescription desc: String) -> URLSessionDownloadTask {
        
        for task in self.runningTasks {
            if let t = task as? URLSessionDownloadTask {
                if t.originalRequest?.url == url || t.currentRequest?.url == url {
                    return t
                }
            }
        }
        
        let task = self.backgroundUrlSession.downloadTask(with: url)
        task.taskDescription = desc
        
        task.resume()
        
        runningTasks.append(task)
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .NetworkerTransferDidStart, object: task)
        }
        
        return task
    }
    
    static func getBaseDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0] as String
        
        return documentsDirectory
    }
    
    static func getUrlSessionDownloadFolderPath() -> String {
        let documentsDirectory = Networker.getBaseDirectory()
        
        let path = documentsDirectory.appending("/downloads")
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
        return path
    }
}

extension Networker: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .NetworkerTransferDidUpdate, object: task)
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        self.taskToResume = task
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .NetworkerTransferNeedsCredentials, object: task)
        }
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let e = error {
            NotificationCenter.default.post(name: .NetworkerTransferDidFailed, object: task, userInfo: ["ERROR": e])
            
            self.runningTasks.removeObject(task)
        }
    }
}

extension Networker: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        var successful = false
        
        if let url = downloadTask.originalRequest?.url {
            
            var targetPath = Networker.getUrlSessionDownloadFolderPath()
            targetPath.append("/")
            targetPath.append("beers")
            
            try? FileManager.default.removeItem(atPath: targetPath) //remove old file
            
            do {
                try FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: targetPath) )
                
                successful = true
                
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
            
        }
        
        self.runningTasks.removeObject(downloadTask)
        
        DispatchQueue.main.async {
            if successful {
                NotificationCenter.default.post(name: .NetworkerTransferDidFinished, object: downloadTask)
            } else {
                NotificationCenter.default.post(name: .NetworkerTransferDidFailed, object: downloadTask)
            }
        }
    }
}
