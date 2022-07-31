//
//  NewDeviceTableViewController.swift
//  AppleTrack
//
//  Created by Dylan McDonald on 7/22/22.
//

import UIKit

class NewDeviceTableViewController: UITableViewController, UITextFieldDelegate {

	@IBOutlet weak var productLineButton: UIButton!
	
	@IBOutlet weak var modelNameField: UITextField!
	@IBOutlet weak var colorField: UITextField!
	@IBOutlet weak var capacityField: UITextField!
	@IBOutlet weak var serialNumberField: UITextField!
	@IBOutlet weak var notesTextView: UITextView!
	@IBOutlet weak var announcementDateLabel: UILabel!
	@IBOutlet weak var shipDateLabel: UILabel!
	@IBOutlet weak var purchaseDateLabel: UILabel!
	
	@IBOutlet weak var setImageCell: StandardCell!
	
	var productLine: String = ""
	var announcementDate: Date = Date()
	var shipDate: Date = Date()
	var purchaseDate: Date = Date()
	var imageToSave: UIImage = UIImage(named: "Fallback Image")!

	var shouldEdit: Bool = false
	var indexToEdit: Int = 0
	
	var imagePicker: ImagePicker!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.imagePicker = ImagePicker(presentationController: self, delegate: self)
		
		productLineButton.layer.cornerCurve = .continuous
		productLineButton.layer.borderColor = UIColor.systemFill.cgColor
		
		tableView.allowsFocus = false
		
		modelNameField.delegate = self
		colorField.delegate = self
		capacityField.delegate = self
		serialNumberField.delegate = self
//		notesField.delegate = self
		
		if shouldEdit {
			productLineButton.setTitle(deviceProductLine(forIndex: indexToEdit), for: .normal)
			modelNameField.text = deviceModelName(forIndex: indexToEdit)
			colorField.text = deviceColor(forIndex: indexToEdit)
			capacityField.text = deviceCapacity(forIndex: indexToEdit)
			serialNumberField.text = deviceSerialNumber(forIndex: indexToEdit)
			notesTextView.text = deviceNotes(forIndex: indexToEdit)
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .medium
			announcementDateLabel.text = dateFormatter.string(from: deviceAnnouncementDate(forIndex: indexToEdit))
			announcementDate = deviceAnnouncementDate(forIndex: indexToEdit)
			shipDateLabel.text = dateFormatter.string(from: deviceReleaseDate(forIndex: indexToEdit))
			shipDate = deviceReleaseDate(forIndex: indexToEdit)
			purchaseDateLabel.text = dateFormatter.string(from: devicePurchaseDate(forIndex: indexToEdit))
			purchaseDate = devicePurchaseDate(forIndex: indexToEdit)
			imageToSave = deviceImage(forIndex: indexToEdit)
			productLine = deviceProductLine(forIndex: indexToEdit)
		}
		
		if runningOn == "Mac" {
			self.view.backgroundColor = .clear
		} else {
			self.navigationController?.navigationBar.prefersLargeTitles = false
			let label = UILabel()
			label.textColor = .label
			label.text = shouldEdit ? "Edit Device" : "New Device"
			self.title = ""
			label.font = UIFont.systemFont(ofSize: (runningOn == "Mac") ? 17 : 22, weight: .semibold)
			self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
		}
    }

	let sheetTransitioningDelegate = SheetTransitioningDelegate()
	
	@IBAction func selectProductLine(_ sender: Any) {
		let viewID = runningOn == "Mac" ? "Product Line Picker" : "Product Line Picker"
		let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewID) as! ProductLinesTableViewController
		view.sourceView = self
		let navView = UINavigationController(rootViewController: view)
		let appearance = UINavigationBarAppearance()
		appearance.configureWithDefaultBackground()
		navView.navigationBar.scrollEdgeAppearance = appearance
		
		if self.viewIsCompact {
			navView.transitioningDelegate = self.sheetTransitioningDelegate
			sheetTransitioningDelegate.shouldShowGrabber = false
			navView.modalPresentationStyle = .custom
		} else {
			navView.modalPresentationStyle = .popover
			let popover: UIPopoverPresentationController = navView.popoverPresentationController!
			popover.sourceView = productLineButton
		}
		
		self.present(navView, animated: true, completion: nil)
	}
	
	@IBAction func cancel(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
	@IBAction func save(_ sender: Any) {
//		print("*** SAVING!")
		let modelName = modelNameField.text ?? ""
		let color = colorField.text ?? ""
		let capacity = capacityField.text ?? ""
		let serialNumber = serialNumberField.text ?? ""
		let notes = notesTextView.text ?? ""
		let imageData = imageToSave.pngData() ?? (UIImage(named: "Fallback Image")!.pngData()!)
		//		let image = 
		
		if shouldEdit {
			saveDeviceProductLine(with: productLine, forIndex: indexToEdit)
			saveDeviceModelName(with: modelName, forIndex: indexToEdit)
			saveDeviceAnnouncementDate(with: announcementDate, forIndex: indexToEdit)
			saveDeviceReleaseDate(with: shipDate, forIndex: indexToEdit)
			saveDevicePurchaseDate(with: purchaseDate, forIndex: indexToEdit)
			saveDeviceColor(with: color, forIndex: indexToEdit)
			saveDeviceCapacity(with: capacity, forIndex: indexToEdit)
			saveDeviceSerialNumber(with: serialNumber, forIndex: indexToEdit)
			saveDeviceNotes(with: notes, forIndex: indexToEdit)
			saveDeviceImage(with: imageData, forIndex: indexToEdit)
			
		} else {
			createNewSavedDevice(productLine: productLine, modelName: modelName, announcementDate: announcementDate, releaseDate: shipDate, purchaseDate: purchaseDate, color: color, capacity: capacity, serialNumber: serialNumber, notes: notes, imageData: imageData)
		}
		NotificationCenter.default.post(name: Notification.Name("UpdateSavedDevices"), object: nil)
		self.dismiss(animated: true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		
		if indexPath.section == 2 {
			let viewID = runningOn == "Mac" ? "Date Picker" : "Date Picker"
			let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewID) as! DatePickerViewController
			
			var dateCategoryToUse: String = ""
			switch indexPath.row {
			case 1:
				dateCategoryToUse = "Announcement"
				if dateFormatter.string(from: announcementDate) == dateFormatter.string(from: Date()) {
					view.dateToSet = shipDate 
				} else {
					view.dateToSet = announcementDate
				}
			case 3:
				dateCategoryToUse = "Ship"
				if dateFormatter.string(from: shipDate) == dateFormatter.string(from: Date()) {
					view.dateToSet = announcementDate 
				} else {
					view.dateToSet = shipDate
				}
			case 5:
				dateCategoryToUse = "Purchase"
				view.dateToSet = purchaseDate
			default:
				break
			}
			
			view.sourceView = self
			view.dateCategory = dateCategoryToUse
			let navView = UINavigationController(rootViewController: view)
			let appearance = UINavigationBarAppearance()
			appearance.configureWithDefaultBackground()
			navView.navigationBar.scrollEdgeAppearance = appearance
			
			if self.viewIsCompact {
				navView.transitioningDelegate = self.sheetTransitioningDelegate
				sheetTransitioningDelegate.shouldShowGrabber = false
				navView.modalPresentationStyle = .custom
			} else {
				navView.modalPresentationStyle = .popover
				let popover: UIPopoverPresentationController = navView.popoverPresentationController!
				popover.sourceView = tableView.cellForRow(at: indexPath)
			}
			
			self.present(navView, animated: true, completion: nil)
		}
		
		if indexPath.section == 7 {
			self.imagePicker.present(from: self.setImageCell.contentView)
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func setDate(with: Date, forCategory: String) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		
		switch forCategory {
		case "Announcement":
			self.announcementDate = with
			self.announcementDateLabel.text = dateFormatter.string(from: with)
		case "Ship":
			self.shipDate = with
			self.shipDateLabel.text = dateFormatter.string(from: with)
		case "Purchase":
			self.purchaseDate = with
			self.purchaseDateLabel.text = dateFormatter.string(from: with)
		default:
			break
		}
	}
   
}

extension NewDeviceTableViewController: ImagePickerDelegate {
	
	func didSelect(image: UIImage?) {
		if image != nil {
			self.setImageCell.accessoryType = .checkmark
			self.imageToSave = image?.fixedOrientation ?? UIImage(named: "Fallback Image")!
		}
	}
}

class AddDeviceMacHostingView: UIViewController {
	var shouldEdit: Bool = false
	var indexToEdit: Int = 0
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var containerView: UIView!
	
	var mainView: NewDeviceTableViewController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		titleLabel.text = shouldEdit ? "Edit Device" : "New Device"
		
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


public protocol ImagePickerDelegate: AnyObject {
	func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
	
	private let pickerController: UIImagePickerController
	private weak var presentationController: UIViewController?
	private weak var delegate: ImagePickerDelegate?
	
	public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
		self.pickerController = UIImagePickerController()
		
		super.init()
		
		self.presentationController = presentationController
		self.delegate = delegate
		
		self.pickerController.delegate = self
		self.pickerController.allowsEditing = false
		self.pickerController.mediaTypes = ["public.image"]
	}
	
	private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
		guard UIImagePickerController.isSourceTypeAvailable(type) else {
			return nil
		}
		
		return UIAlertAction(title: title, style: .default) { [unowned self] _ in
			self.pickerController.sourceType = type
			self.presentationController?.present(self.pickerController, animated: true)
		}
	}
	
	public func present(from sourceView: UIView) {
		
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		if let action = self.action(for: .camera, title: "Take Photo") {
			if runningOn != "Mac" {
				alertController.addAction(action)
			}
		}
		//        if let action = self.action(for: .savedPhotosAlbum, title: "Camera Roll") {
		//            alertController.addAction(action)
		//        }
		
		if let action = self.action(for: .photoLibrary, title: "Photo Library") {
			alertController.addAction(action)
		}
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
//		if runningOn != "iPhone" {
			alertController.popoverPresentationController?.sourceView = sourceView
			alertController.popoverPresentationController?.sourceRect = sourceView.bounds
			alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
//		}
		
		
		self.presentationController?.present(alertController, animated: true)
	}
	
	private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
		controller.dismiss(animated: true, completion: nil)
		
		self.delegate?.didSelect(image: image)
	}
}

extension ImagePicker: UIImagePickerControllerDelegate {
	
	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.pickerController(picker, didSelect: nil)
	}
	
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		guard let image = info[.originalImage] as? UIImage else {
			return self.pickerController(picker, didSelect: nil)
		}
		self.pickerController(picker, didSelect: image)
	}
}

extension ImagePicker: UINavigationControllerDelegate {
	
}

extension UIImage {
	var fixedOrientation: UIImage {
		guard imageOrientation != .up else { return self }
		
		var transform: CGAffineTransform = .identity
		switch imageOrientation {
		case .down, .downMirrored:
			transform = transform
				.translatedBy(x: size.width, y: size.height).rotated(by: .pi)
		case .left, .leftMirrored:
			transform = transform
				.translatedBy(x: size.width, y: 0).rotated(by: .pi)
		case .right, .rightMirrored:
			transform = transform
				.translatedBy(x: 0, y: size.height).rotated(by: -.pi/2)
		case .upMirrored:
			transform = transform
				.translatedBy(x: size.width, y: 0).scaledBy(x: -1, y: 1)
		default:
			break
		}
		
		guard
			let cgImage = cgImage,
			let colorSpace = cgImage.colorSpace,
			let context = CGContext(
				data: nil, width: Int(size.width), height: Int(size.height),
				bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
				space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue
			)
		else { return self }
		context.concatenate(transform)
		
		var rect: CGRect
		switch imageOrientation {
		case .left, .leftMirrored, .right, .rightMirrored:
			rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
		default:
			rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		}
		
		context.draw(cgImage, in: rect)
		return context.makeImage().map { UIImage(cgImage: $0) } ?? self
	}
}
