//
//  NewDeviceTableViewController.swift
//  AppleTrack
//
//  Created by Dylan McDonald on 7/22/22.
//

import UIKit

class NewDeviceTableViewController: UITableViewController, UITextFieldDelegate {

	@IBOutlet weak var productLineField: UITextField!
	@IBOutlet weak var modelNameField: UITextField!
	@IBOutlet weak var colorField: UITextField!
	@IBOutlet weak var capacityField: UITextField!
	@IBOutlet weak var serialNumberField: UITextField!
	@IBOutlet weak var notesField: UITextField!
	@IBOutlet weak var announcementDatePicker: UIDatePicker!
	@IBOutlet weak var shipDatePicker: UIDatePicker!
	@IBOutlet weak var purchaseDatePicker: UIDatePicker!

	var shouldEdit: Bool = false
	var indexToEdit: Int = 0
	
	//	@IBOutlet weak var productLineButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
//		productLineButton.layer.cornerCurve = .continuous
//		productLineButton.layer.borderColor = UIColor.systemFill.cgColor
		
		tableView.allowsFocus = false
		
		productLineField.delegate = self
		modelNameField.delegate = self
		colorField.delegate = self
		capacityField.delegate = self
		serialNumberField.delegate = self
		notesField.delegate = self
		
		if shouldEdit {
			productLineField.text = deviceProductLine(forIndex: indexToEdit)
			modelNameField.text = deviceModelName(forIndex: indexToEdit)
			colorField.text = deviceColor(forIndex: indexToEdit)
			capacityField.text = deviceCapacity(forIndex: indexToEdit)
			serialNumberField.text = deviceSerialNumber(forIndex: indexToEdit)
			notesField.text = deviceNotes(forIndex: indexToEdit)
			announcementDatePicker.date = deviceAnnouncementDate(forIndex: indexToEdit)
			shipDatePicker.date = deviceReleaseDate(forIndex: indexToEdit)
			purchaseDatePicker.date = devicePurchaseDate(forIndex: indexToEdit)
		}
    }

	
	@IBAction func cancel(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
	@IBAction func save(_ sender: Any) {
//		print("*** SAVING!")
		let productLine = productLineField.text ?? ""
		let modelName = modelNameField.text ?? ""
		let announcementDate = announcementDatePicker.date
		let releaseDate = shipDatePicker.date
		let purchaseDate = purchaseDatePicker.date
		let color = colorField.text ?? ""
		let capacity = capacityField.text ?? ""
		let serialNumber = serialNumberField.text ?? ""
		let notes = notesField.text ?? ""
		//		let image = 
		
		if shouldEdit {
			saveDeviceProductLine(with: productLine, forIndex: indexToEdit)
			saveDeviceModelName(with: modelName, forIndex: indexToEdit)
			saveDeviceAnnouncementDate(with: announcementDate, forIndex: indexToEdit)
			saveDeviceReleaseDate(with: releaseDate, forIndex: indexToEdit)
			saveDevicePurchaseDate(with: purchaseDate, forIndex: indexToEdit)
			saveDeviceColor(with: color, forIndex: indexToEdit)
			saveDeviceCapacity(with: capacity, forIndex: indexToEdit)
			saveDeviceSerialNumber(with: serialNumber, forIndex: indexToEdit)
			saveDeviceNotes(with: notes, forIndex: indexToEdit)
			
		} else {
			createNewSavedDevice(productLine: productLine, modelName: modelName, announcementDate: announcementDate, releaseDate: releaseDate, purchaseDate: purchaseDate, color: color, capacity: capacity, serialNumber: serialNumber, notes: notes, imageData: UIImage(named: "Fallback Image")!.pngData()!)
		}
		NotificationCenter.default.post(name: Notification.Name("UpdateSavedDevices"), object: nil)
		self.dismiss(animated: true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
   
}

class AddDeviceMacHostingView: UIViewController {
	var shouldEdit: Bool = false
	var indexToEdit: Int = 0
	
	@IBOutlet weak var containerView: UIView!
	
	var mainView: NewDeviceTableViewController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mainView = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add Device") as! NewDeviceTableViewController)
		mainView.shouldEdit = shouldEdit
		mainView.indexToEdit = indexToEdit
		
		addChild(mainView)
		mainView.view.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(mainView.view)
		
		NSLayoutConstraint.activate([
			mainView.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			mainView.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			mainView.view.topAnchor.constraint(equalTo: containerView.topAnchor),
			mainView.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
		])
		
		mainView.didMove(toParent: self)
	}
	
	@IBAction func cancel(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
	@IBAction func save(_ sender: Any) {
		mainView.save(sender)
		self.dismiss(animated: true)
	}
	
}
