//
//  Record.swift
//  Record
//
//  Created by Lahari Ganti on 10/8/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import CloudKit
import Foundation

class Record: NSObject {
	var recordID: CKRecord.ID!
	var creationDate: Date!
	var audio: URL?
	var audioIsPlaying: Bool = false
	var didFinishPlaying: Bool = false
}
