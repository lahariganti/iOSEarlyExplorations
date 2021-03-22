//
//  RecordingsInteractor.swift
//  Record
//
//  Created by Lahari Ganti on 10/9/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import CloudKit

class RecordingsInteractor: NSObject {
	let customContainer = CKContainer(identifier: "iCloud.com.gmail.gplahari.Recordings")

	func saveRecording(_ audioRecord: CKRecord, _ completionHandler: @escaping (CKRecord?, Error?) -> Void) {
		customContainer.publicCloudDatabase.save(audioRecord) { record, error in
			if let error = error {
				completionHandler(nil, error)
			} else {
				completionHandler(record, nil)
			}
		}
	}

	func fetchRecordings(_ completionHandler: @escaping ([Record], Error?) -> Void) {
		var newRecords = [Record]()
		let pred = NSPredicate(value: true)
			let sort = NSSortDescriptor(key: "creationDate", ascending: true)
			let query = CKQuery(recordType: "Records", predicate: pred)
			query.sortDescriptors = [sort]

			let operation = CKQueryOperation(query: query)
			operation.resultsLimit = 50

			operation.recordFetchedBlock = { record in
				let newRecord = Record()
				newRecord.recordID = record.recordID
				newRecord.creationDate = record.creationDate
				newRecords.append(newRecord)
			}

			operation.queryCompletionBlock = {(_, error) in
				if error == nil {
					completionHandler(newRecords, nil)
				} else {
					completionHandler([], error)
				}
			}

			customContainer.publicCloudDatabase.add(operation)
	}

	func fetchSelectedRecord(with id: CKRecord.ID, _ completionHandler: @escaping (URL?, Error?) -> Void) {
		customContainer.publicCloudDatabase.fetch(withRecordID: id) { record, error in
			if let error = error {
				completionHandler(nil, error)
			} else {
				if let record = record {
					if let asset = record["audio"] as? CKAsset {
						completionHandler(asset.fileURL, nil)
					}
				}
			}
		}
	}

	func deleteSelectedRecord(with id: CKRecord.ID, _ completionHandler: @escaping (Record?, Error?) -> Void) {
		customContainer.publicCloudDatabase.delete(withRecordID: id) { (record, error) in
			if let error = error {
				completionHandler(nil, error)
			} else {
				if let record = record {
					let recordToBeDeleted = Record()
					recordToBeDeleted.recordID = record
					completionHandler(recordToBeDeleted, nil)
				}
			}
		}
	}
}
