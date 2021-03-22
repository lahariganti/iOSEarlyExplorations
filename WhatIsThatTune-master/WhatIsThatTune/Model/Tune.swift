//
//  Tune.swift
//  WhatIsThatTune
//
//  Created by Lahari Ganti on 9/9/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation
import CloudKit

class Tune: NSObject {
	var recordID: CKRecord.ID!
	var genre: String!
	var comments: String!
	var audio: URL!
}
