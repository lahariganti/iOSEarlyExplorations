//
//  DownloadManager.swift
//  TriangleStaff
//
//  Created by Lahari Ganti on 6/17/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class DownloadManager: NSObject {
    var session: URLSession
    let url: URL
    var shouldCache: Bool

    init(url: URL, shouldCache: Bool) {
        session = URLSession(configuration: URLSessionConfiguration.default)
        self.url = url
        self.shouldCache = shouldCache
        super.init()
    }

    convenience init(url: URL) {
        self.init(url: url, shouldCache: true)
    }

    func download(completion: @escaping (_ data: Data?, _ error : Error?) -> Void) {
        session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(nil, error as Error?)
            }

            if let _ = data {
                completion(data as Data?, nil)
            }

            self.session.finishTasksAndInvalidate()
        }).resume()
 
    }

    func storeInCache(object: AnyObject){
        if self.shouldCache {
            CacheManager.sharedCache.archiveAnyOther(any: object, url: url.absoluteString)
        }
    }

    public func getImage(completion: @escaping (_ url: URL, _ image: UIImage?, _ error : Error?) -> Void) {
        if let cachedImage = CacheManager.sharedCache.unarchiveImage(url: self.url.absoluteString) {
            DispatchQueue.main.async() {
                completion(self.url, cachedImage, nil)
            }
            return
        } else {
            download{ (data, error) -> Void in
                DispatchQueue.main.async() {
                    if let data = data, let currentImage = UIImage(data: data as Data) {
                        self.storeInCache(object: currentImage)
                        completion(self.url, currentImage, nil)
                    } else {
                        completion(self.url, nil, error as Error?)
                    }
                }
            }
        }
    }

    public func getData(completion: @escaping (_ url: URL, _ data: Data?, _ error : Error?) -> Void) {
        self.download{ (data, error) -> Void in
            DispatchQueue.main.async() {
                if error == nil , let data = data as NSObject? {
                    self.storeInCache(object: data)
                }

                completion(self.url, data, error)
            }
        }
    }

    public func getJSON(completion: @escaping (_ url: URL, _ json: [String: AnyObject]?, _ error : Error?) -> Void) {
        if let cachedJson = CacheManager.sharedCache.unarchiveJSON(url: self.url.absoluteString) {
            DispatchQueue.main.async() {
                completion(self.url, cachedJson, nil)
                return
            }
        } else {
            download{ (data, error) -> Void in
                do {
                    if let data = data, let json = try JSONSerialization.jsonObject(with: data as Data, options:.allowFragments) as? [String: AnyObject] {
                        self.storeInCache(object: json as AnyObject)
                        completion(self.url, json, nil)
                    } else {
                        completion(self.url, nil,  error)
                    }
                }
                catch let error {
                    completion(self.url, nil, error)
                }
            }
        }
    }

    public func cancel(url: URL) {
        session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) -> Void in
            let tasks = dataTasks.filter({ (currentTask) -> Bool in
                return ((currentTask.originalRequest?.url)! == url as URL)
            })

            tasks.forEach{ $0.cancel() }
        }
    }
}
