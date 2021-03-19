//
//  CacheManager.swift
//  TriangleStaff
//
//  Created by Lahari Ganti on 6/17/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

public class CacheManager {
    static public let sharedCache = CacheManager()
    let imageCache = NSCache<AnyObject, DiscradableImage>()
    let dataCache = NSCache<AnyObject, DiscardableData>()
    let jsonCache = NSCache<AnyObject, DiscardableJSON>()

    public init(countLimit: Int, totalCostLimit: Int) {
        imageCache.countLimit = countLimit
        dataCache.countLimit = countLimit
        jsonCache.countLimit = countLimit

        imageCache.totalCostLimit = totalCostLimit
        dataCache.totalCostLimit = totalCostLimit
        jsonCache.totalCostLimit = totalCostLimit
    }

    convenience init(){
        self.init(countLimit: 0, totalCostLimit: 0)
    }

    public func archiveImage(image: UIImage?, url: String) {
        guard let image = image else {
            imageCache.removeObject(forKey: url as NSString)
            return
        }
        
        let data = DiscradableImage(image: image)
        imageCache.setObject(data, forKey: url as NSString)
    }

    public func archiveAnyOther(any: AnyObject?, url: String) {
        if any == nil {
            dataCache.removeObject(forKey: url as NSString)
            return
        }
    }

    public func unarchiveImage(url: String?) -> UIImage? {
        guard let url = url else { return nil }
        if url.isEmpty { return nil }
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            return cachedImage.image
        }

        return nil
    }


    public func unarchiveJSON(url: String?) -> [String: AnyObject]? {
        guard let url = url else { return nil }
        if url.isEmpty { return nil }

        if let cachedJSON = jsonCache.object(forKey: url as NSString) {
            return cachedJSON.json
        }

        return nil
    }

    public func unarchiveData(url: String?) -> Data? {
        guard let url = url else { return nil }
        if url.isEmpty { return nil }

        if let cachedData = dataCache.object(forKey: url as NSString) {
            return cachedData.data
        }

        return nil
    }

    public func clearCache() {
        imageCache.removeAllObjects()
        dataCache.removeAllObjects()
        jsonCache.removeAllObjects()
    }
}
