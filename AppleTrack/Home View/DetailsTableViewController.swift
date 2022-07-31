//
//  DetailsTableViewController.swift
//  AppleTrack
//
//  Created by Dylan McDonald on 7/22/22.
//

import UIKit

class DetailsTableViewController: UITableViewController {
	
	var indexToUse: Int = 0
	
	@IBOutlet weak var backButtonBlur: UIVisualEffectView!
	@IBOutlet weak var editButtonBlur: UIVisualEffectView!
	@IBOutlet weak var deleteButtonBlur: UIVisualEffectView!
	
	@IBOutlet weak var modelNameTitle: UILabel!
	@IBOutlet weak var headerImage: UIImageView!
	@IBOutlet weak var productLineLabel: UILabel!
	@IBOutlet weak var announcementDateLabel: UILabel!
	@IBOutlet weak var releaseDateLabel: UILabel!
	@IBOutlet weak var purchaseDateLabel: UILabel!
	@IBOutlet weak var colorLabel: UILabel!
	@IBOutlet weak var storageCapacityLabel: UILabel!
	@IBOutlet weak var serialNumberLabel: UILabel!
	@IBOutlet weak var notesLabel: UILabel!
	
	
	@IBOutlet weak var headerImageTopConstraint: NSLayoutConstraint!
//	@IBOutlet weak var headerImageHeightConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.view.tintColor = .white
		if let splitViewController = self.splitViewController {
			if splitViewController.viewIsCompact {
				editButtonBlur.isHidden = true
				deleteButtonBlur.isHidden = true
				self.navigationController?.isNavigationBarHidden = false
			} else {
				editButtonBlur.isHidden = false
				deleteButtonBlur.isHidden = false
				self.navigationController?.isNavigationBarHidden = true
			}
		}
	
		var heightValue: CGFloat = 35
		if runningOn == "Mac" {
			heightValue = 27
		}
		backButtonBlur.layer.cornerRadius = heightValue / 2
		backButtonBlur.clipsToBounds = true
		editButtonBlur.layer.cornerRadius = heightValue / 2
		editButtonBlur.clipsToBounds = true
		deleteButtonBlur.layer.cornerRadius = heightValue / 2
		deleteButtonBlur.clipsToBounds = true
		
		setData()
		
		if runningOn == "Mac" {
			self.view.backgroundColor = .clear
		}
		
		DispatchQueue.main.async {
			let scrollView = self.tableView as UIScrollView
			self.headerImageTopConstraint.constant = scrollView.contentOffset.y
		}
		
		tableView.allowsFocus = false
		
		NotificationCenter.default.addObserver(self, selector: #selector(UpdateSavedDevices(_:)), name: NSNotification.Name(rawValue: "UpdateSavedDevices"), object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if runningOn != "Mac" {
			self.navigationController?.view.tintColor = .white
		}
	}
	
	@objc func UpdateSavedDevices(_ notification: Notification) {
		setData()
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		if self.traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
			if let splitViewController = self.splitViewController {
				if splitViewController.viewIsCompact {
					editButtonBlur.isHidden = true
					deleteButtonBlur.isHidden = true
					self.navigationController?.isNavigationBarHidden = false
				} else {
					editButtonBlur.isHidden = false
					deleteButtonBlur.isHidden = false
					self.navigationController?.isNavigationBarHidden = true
				}
			}
		}
	}
	
	@IBAction func showImage(_ sender: Any) {
		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Image Viewer") as! ImageViewerViewController
		vc.indexToUse = indexToUse
		
		let navView = UINavigationController(rootViewController: vc)
		
		navView.modalPresentationStyle = .pageSheet
		present(navView, animated: true)
	}
	
	func setData() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .full
		
		modelNameTitle.text = deviceModelName(forIndex: indexToUse)
		headerImage.image = deviceImage(forIndex: indexToUse)
		productLineLabel.text = deviceProductLine(forIndex: indexToUse)
		announcementDateLabel.text = dateFormatter.string(from: deviceAnnouncementDate(forIndex: indexToUse))
		releaseDateLabel.text = dateFormatter.string(from: deviceReleaseDate(forIndex: indexToUse))
		purchaseDateLabel.text = dateFormatter.string(from: devicePurchaseDate(forIndex: indexToUse))
		colorLabel.text = deviceColor(forIndex: indexToUse)
		storageCapacityLabel.text = deviceCapacity(forIndex: indexToUse)
		serialNumberLabel.text = deviceSerialNumber(forIndex: indexToUse)
		notesLabel.text = deviceNotes(forIndex: indexToUse)
		if notesLabel.text == "" || notesLabel.text == "No notes" {
			notesLabel.text = "No notes"
			notesLabel.textColor = .secondaryLabel
		} else {
			notesLabel.textColor = .label
		}
	}
	
	@IBAction func back(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func edit(_ sender: Any) {
		if runningOn == "Mac" {
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add Device Mac") as! AddDeviceMacHostingView
			vc.shouldEdit = true
			vc.indexToEdit = indexToUse
			
			vc.modalPresentationStyle = .formSheet
			vc.preferredContentSize = CGSize(width: 350, height: 600)
			present(vc, animated: true)
		} else {
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add Device") as! NewDeviceTableViewController
			vc.shouldEdit = true
			vc.indexToEdit = indexToUse
			
			let nav = UINavigationController(rootViewController: vc)
			nav.modalPresentationStyle = .formSheet
			
			present(nav, animated: true)
		}
	}
	
	@IBAction func deleteDevice(_ sender: Any) {
		let alertController = UIAlertController(title: "Are you sure?", message: "This will permanently remove this device from AppleTrack.", preferredStyle: .alert)
		
		let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
		}
		
		let action1 = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
			deleteAllDataForSavedDevice(atIndex: self.indexToUse, shouldReload: true)
			self.navigationController?.popViewController(animated: true)
		}
		
		alertController.addAction(action1)
		alertController.addAction(action2)
		alertController.actions[0].setValue(UIColor(named: "AccentColor")!, forKey: "titleTextColor")
		alertController.view.tintColor = UIColor(named: "AccentColor")!
		self.present(alertController, animated: true, completion: nil)
	}
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		if scrollView.contentOffset.y < 0 {
////			self.headerImageTopConstraint.constant = self.headerImageTopConstraint.constant - abs(scrollView.contentOffset.y)
//			self.headerImageHeightConstraint.constant += abs(scrollView.contentOffset.y)
//		}
		print(scrollView.contentOffset.y)
		self.headerImageTopConstraint.constant = scrollView.contentOffset.y
	}
}

class ImageViewerViewController: UIViewController {
	
	var indexToUse: Int = 0
	
	@IBOutlet weak var mainImageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.mainImageView.image = deviceImage(forIndex: indexToUse)
		
		self.navigationController?.navigationBar.prefersLargeTitles = false
		let label = UILabel()
		label.textColor = .label
		label.text = "Device Image"
		self.title = ""
		label.font = UIFont.systemFont(ofSize: (runningOn == "Mac") ? 17 : 22, weight: .semibold)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
	}
	
	@IBAction func shareImage(_ sender: Any) {
		let ac = UIActivityViewController(activityItems: [deviceImage(forIndex: indexToUse)], applicationActivities: nil)
		ac.title = "AppleTrack Device Image"
		ac.popoverPresentationController?.sourceView = (sender as! UIView)
		ac.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
		self.present(ac, animated: true)
	}
	
	@IBAction func dismiss(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
}
