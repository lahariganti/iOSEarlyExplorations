//
//  MinervaAndCache.swift
//  Minerva
//
//  Created by Lahari Ganti on 6/17/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

func download(url: URL) -> DownloadManager {
    return DownloadManager(url: url)
}

func download(url: URL, shouldCache: Bool) -> DownloadManager {
    return DownloadManager(url: url, shouldCache: shouldCache)
}
