//
//  SavedDevices Data Model.swift
//  AppleTrack
//
//  Created by Dylan McDonald on 7/22/22.
//

import Foundation
import CoreData
import UIKit

var savedDevicesData: [NSManagedObject] = []
var SavedProductLines: [String] = []

func getSavedDevicesData() {
	guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
		return
	}
	let managedContext = appDelegate.persistentContainer.viewContext
	managedContext.automaticallyMergesChangesFromParent = true
	
	let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedDevices")
	fetchRequest.sortDescriptors = [NSSortDescriptor(key: "productLine", ascending: true), NSSortDescriptor(key: "releaseDate", ascending: true)]
	
	do {
		savedDevicesData = try managedContext.fetch(fetchRequest)
		SavedProductLines = []
		for Entity in savedDevicesData as [NSManagedObject] {
			let valueForKey = Entity.value(forKey: "productLine") as? String ?? ""
			SavedProductLines.append(valueForKey)
		}
	} catch let error as NSError {
		print("Could not fetch data. \(error), \(error.userInfo)")
	}
	NotificationCenter.default.post(name: Notification.Name("UpdateSavedDevices"), object: nil)
}

// Create a new entry
func createNewSavedDevice(productLine: String, modelName: String, announcementDate: Date, releaseDate: Date, purchaseDate: Date, color: String, capacity: String, serialNumber: String, notes: String, imageData: Data) {
	guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
		return
	}
	let managedContext = appDelegate.persistentContainer.viewContext
	managedContext.automaticallyMergesChangesFromParent = true
	let entity = NSEntityDescription.entity(forEntityName: "SavedDevices", in: managedContext)!
	let dataToSave = NSManagedObject(entity: entity, insertInto: managedContext)
	
	dataToSave.setValue(productLine, forKeyPath: "productLine")
	dataToSave.setValue(modelName, forKeyPath: "modelName")
	dataToSave.setValue(announcementDate, forKeyPath: "announcementDate")
	dataToSave.setValue(releaseDate, forKeyPath: "releaseDate")
	dataToSave.setValue(purchaseDate, forKeyPath: "purchaseDate")
	dataToSave.setValue(color, forKeyPath: "color")
	dataToSave.setValue(capacity, forKeyPath: "capacity")
	dataToSave.setValue(serialNumber, forKeyPath: "serialNumber")
	dataToSave.setValue(notes, forKeyPath: "notes")
	dataToSave.setValue(imageData, forKeyPath: "image")
	
	do {
		managedContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
		try managedContext.save()
		savedDevicesData.append(dataToSave)
	} catch let error as NSError {
		print("Could not save data. \(error), \(error.userInfo)")
	}
}

// Get a specific value
func deviceProductLine(forIndex: Int) -> String {
	var toReturn: String = ""
	if savedDevicesData.indices.contains(forIndex) {
		toReturn = savedDevicesData[forIndex].value(forKeyPath: "productLine") as? String ?? ""
	}
	return toReturn
}

func deviceModelName(forIndex: Int) -> String {
	var toReturn: String = ""
	if savedDevicesData.indices.contains(forIndex) {
		toReturn = savedDevicesData[forIndex].value(forKeyPath: "modelName") as? String ?? ""
	}
	return toReturn
}

func deviceAnnouncementDate(forIndex: Int) -> Date {
	var toReturn: Date = Date()
	if savedDevicesData.indices.contains(forIndex) {
		toReturn = savedDevicesData[forIndex].value(forKeyPath: "announcementDate") as? Date ?? Date()
	}
	return toReturn
}

func deviceReleaseDate(forIndex: Int) -> Date {
	var toReturn: Date = Date()
	if savedDevicesData.indices.contains(forIndex) {
		toReturn = savedDevicesData[forIndex].value(forKeyPath: "releaseDate") as? Date ?? Date()
	}
	return toReturn
}

func devicePurchaseDate(forIndex: Int) -> Date {
	var toReturn: Date = Date()
	if savedDevicesData.indices.contains(forIndex) {
		toReturn = savedDevicesData[forIndex].value(forKeyPath: "purchaseDate") as? Date ?? Date()
	}
	return toReturn
}

func deviceColor(forIndex: Int) -> String {
	var toReturn: String = ""
	if savedDevicesData.indices.contains(forIndex) {
		toReturn = savedDevicesData[forIndex].value(forKeyPath: "color") as? String ?? ""
	}
	return toReturn
}

func deviceCapacity(forIndex: Int) -> String {
	var toReturn: String = ""
	if savedDevicesData.indices.contains(forIndex) {
		toReturn = savedDevicesData[forIndex].value(forKeyPath: "capacity") as? String ?? ""
	}
	return toReturn
}

func deviceSerialNumber(forIndex: Int) -> String {
	var toReturn: String = ""
	if savedDevicesData.indices.contains(forIndex) {
		toReturn = savedDevicesData[forIndex].value(forKeyPath: "serialNumber") as? String ?? ""
	}
	return toReturn
}

func deviceNotes(forIndex: Int) -> String {
	var toReturn: String = ""
	if savedDevicesData.indices.contains(forIndex) {
		toReturn = savedDevicesData[forIndex].value(forKeyPath: "notes") as? String ?? ""
	}
	return toReturn
}

func deviceImage(forIndex: Int) -> UIImage {
	var toReturn: UIImage = UIImage(named: "Fallback Image")!
	if savedDevicesData.indices.contains(forIndex) {
		toReturn = UIImage(data: (savedDevicesData[forIndex].value(forKeyPath: "image") as? Data ?? UIImage(named: "Fallback Image")!.pngData()!)) ?? UIImage(named: "Fallback Image")!
	}
	return toReturn
}


// Update a specific value
func saveToSavedDevicesData(key: String, data: Any, forIndex: Int) {
	guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
		return
	}
	let managedContext = appDelegate.persistentContainer.viewContext
	managedContext.automaticallyMergesChangesFromParent = true
	let dataToSave = savedDevicesData[forIndex]
	dataToSave.setValue(data, forKeyPath: key)
	do {
		managedContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
		try managedContext.save()
	} catch let error as NSError {
		print("Could not save data. \(error), \(error.userInfo)")
	}
}

func saveDeviceProductLine(with: String, forIndex: Int) {
	saveToSavedDevicesData(key: "productLine", data: with, forIndex: forIndex)
}

func saveDeviceModelName(with: String, forIndex: Int) {
	saveToSavedDevicesData(key: "modelName", data: with, forIndex: forIndex)
}

func saveDeviceAnnouncementDate(with: Date, forIndex: Int) {
	saveToSavedDevicesData(key: "announcementDate", data: with, forIndex: forIndex)
}

func saveDeviceReleaseDate(with: Date, forIndex: Int) {
	saveToSavedDevicesData(key: "releaseDate", data: with, forIndex: forIndex)
}

func saveDevicePurchaseDate(with: Date, forIndex: Int) {
	saveToSavedDevicesData(key: "purchaseDate", data: with, forIndex: forIndex)
}

func saveDeviceColor(with: String, forIndex: Int) {
	saveToSavedDevicesData(key: "color", data: with, forIndex: forIndex)
}

func saveDeviceSerialNumber(with: String, forIndex: Int) {
	saveToSavedDevicesData(key: "serialNumber", data: with, forIndex: forIndex)
}

func saveDeviceCapacity(with: String, forIndex: Int) {
	saveToSavedDevicesData(key: "capacity", data: with, forIndex: forIndex)
}

func saveDeviceNotes(with: String, forIndex: Int) {
	saveToSavedDevicesData(key: "notes", data: with, forIndex: forIndex)
}

func saveDeviceImage(with: Data, forIndex: Int) {
	saveToSavedDevicesData(key: "image", data: with, forIndex: forIndex)
}





func deleteAllDataForSavedDevice(atIndex: Int, shouldReload: Bool) {
	guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
		return
	}
	let managedContext = appDelegate.persistentContainer.viewContext
	managedContext.automaticallyMergesChangesFromParent = true
	let company = savedDevicesData[atIndex]
	managedContext.delete(company)
	do {
		managedContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
		try managedContext.save()
	} catch let error as NSError {
		print("Error While Deleting Note: \(error.userInfo)")
		
	}
	if shouldReload {
		getSavedDevicesData()
	} else {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let managedContext = appDelegate.persistentContainer.viewContext
		managedContext.automaticallyMergesChangesFromParent = true
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedDevices")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "productLine", ascending: true), NSSortDescriptor(key: "releaseDate", ascending: true)]
		
		do {
			savedDevicesData = try managedContext.fetch(fetchRequest)

		} catch let error as NSError {
			print("Could not fetch data. \(error), \(error.userInfo)")
		}
	}
}

func clearAllSavedDevices() {
	if savedDevicesData.count > 0 {
		for atIndex in 0...savedDevicesData.count - 1 {
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
				return
			}
			let managedContext = appDelegate.persistentContainer.viewContext
			managedContext.automaticallyMergesChangesFromParent = true
			let company = savedDevicesData[atIndex]
			managedContext.delete(company)
			do {
				managedContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
				try managedContext.save()
			} catch let error as NSError {
				print("Error While Deleting Note: \(error.userInfo)")
				
			}
		}
		getSavedDevicesData()
	}
	//	NotificationCenter.default.post(name: Notification.Name("UpdateSavedDevices"), object: nil)
}
