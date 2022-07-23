//
//  HomeTableViewController.swift
//  AppleTrack
//
//  Created by Dylan McDonald on 7/22/22.
//

import UIKit

class HomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		getSavedDevicesData()
		
		self.navigationController?.isNavigationBarHidden = false
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.sizeToFit()
		
		if runningOn == "Mac" {
			self.navigationController?.isNavigationBarHidden = true
			self.view.backgroundColor = .clear
		}
		
		tableView.allowsFocus = false
		
		NotificationCenter.default.addObserver(self, selector: #selector(UpdateSavedDevices(_:)), name: NSNotification.Name(rawValue: "UpdateSavedDevices"), object: nil)
    }
	
	@objc func UpdateSavedDevices(_ notification: Notification) {
		tableView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = false
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.sizeToFit()
		
		DispatchQueue.main.async {
			#if targetEnvironment(macCatalyst)
			if let session = (self.view.window?.windowScene?.session) {
				updateTitleBar(withDelegate: HomeToolbarDelegate(), withTitle: "AppleTrack", withSubtitle: "Devices", iconMode: .iconOnly, sender: self, session: session)
			}
			#endif
		}
		
		if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
			self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {

	}
	
	@IBAction func newDevice(_ sender: Any) {
		if runningOn == "Mac" {
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add Device Mac") as! AddDeviceMacHostingView
			vc.shouldEdit = false
			
			vc.modalPresentationStyle = .formSheet
			vc.preferredContentSize = CGSize(width: 350, height: 600)
			present(vc, animated: false)
		}
	}
	
	@IBAction func refreshData(_ sender: Any) {
		getSavedDevicesData()
	}
	
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return savedDevicesData.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let index = indexPath.section // - 1
//		var cell: UITableViewCell!
		//		if indexPath.section == 0 {
		//			cell = self.tableView.dequeueReusableCell(withIdentifier: "stats cell", for: indexPath)
		//		} else {
//		if isNoData {
//			cell = self.tableView.dequeueReusableCell(withIdentifier: "no data cell", for: indexPath)
//		} else {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		let releaseYear = dateFormatter.string(from: deviceReleaseDate(forIndex: index))
		
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "main cell", for: indexPath) as! DeviceListCell
		cell.titleLabel.text = deviceModelName(forIndex: index)
		cell.subtitleLabel.text = deviceColor(forIndex: index) + " • " + releaseYear
		cell.deviceImage.image = deviceImage(forIndex: index)
			
//		}
		//		}
	
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Device Details") as! DetailsTableViewController)
		vc.indexToUse = indexPath.section
		
//		if runningOn == "Mac" {
//			vc.modalTransitionStyle = .crossDissolve
//			vc.modalPresentationStyle = .fullScreen
//			self.present(vc, animated: true)
//			//			tableView.deselectRow(at: indexPath, animated: true)
//		} else {
		if let splitViewController = self.splitViewController {
			if splitViewController.viewIsCompact {
				self.show(vc, sender: nil)
			} else {
				self.showDetailViewController(vc, sender: nil)
			}
		} else {
			self.show(vc, sender: nil)
		}
//		}
	}

	
	
	var previewIndex: IndexPath = [0,0]
	override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(identifier: nil, previewProvider: {
			let index = indexPath.section // - 1
			let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Device Details") as! DetailsTableViewController)
			vc.indexToUse = index
			self.previewIndex = indexPath
			return vc
		}, actionProvider: { suggestedActions in
			return self.makeContextMenu(indexPath: indexPath)
		})
	}
	
	
	override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
		animator.addCompletion {
			let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Device Details") as! DetailsTableViewController)
			vc.indexToUse = self.previewIndex.section
			self.show(vc, sender: nil)
		}
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt selectedIndexPath: IndexPath) ->   UISwipeActionsConfiguration? {
		
		let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completionHandler) in
			self.deleteAction(indexPath: selectedIndexPath)
		})
		delete.image = UIImage(systemName: "trash")
		delete.backgroundColor = .systemRed
		
		let configuration = UISwipeActionsConfiguration(actions: [delete])
		return configuration
	}
	
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt selectedIndexPath: IndexPath) ->   UISwipeActionsConfiguration? {
		
		let edit = UIContextualAction(style: .normal, title: "Edit", handler: { (action, view, completionHandler) in
			self.editAction(indexPath: selectedIndexPath)
		})
		edit.image = UIImage(systemName: "pencil")
		edit.backgroundColor = UIColor(named: "AccentColor")!
		
//		let share = UIContextualAction(style: .normal, title: "Share", handler: { (action, view, completionHandler) in
//			self.shareAction(indexPath: selectedIndexPath)
//		})
//		share.image = UIImage(systemName: "square.and.arrow.up")
//		share.backgroundColor = UIColor(named: "AccentColor")!.withAlphaComponent(0.6)
		
		let configuration = UISwipeActionsConfiguration(actions: [edit])
		return configuration
	}
	
	private func makeContextMenu(indexPath: IndexPath) -> UIMenu {
		
		let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
			self.deleteAction(indexPath: indexPath)
		}
		
		let edit = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { action in
			self.editAction(indexPath: indexPath)
		}
		
//		let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
//			self.shareAction(indexPath: indexPath)
//		}
		
		return UIMenu(title: "Options", children: [edit, delete])
	}
	
	func deleteAction(indexPath: IndexPath) {
		let alertController = UIAlertController(title: "Are you sure?", message: "This will permanently remove this device from AppleTrack.", preferredStyle: .alert)
		
		let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
		}
		
		let action1 = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
			deleteAllDataForSavedDevice(atIndex: indexPath.section, shouldReload: false)
			self.tableView.deleteSections([indexPath.section], with: .middle)
		}
		
		alertController.addAction(action1)
		alertController.addAction(action2)
		alertController.actions[0].setValue(UIColor(named: "AccentColor")!, forKey: "titleTextColor")
		alertController.view.tintColor = UIColor(named: "AccentColor")!
		self.present(alertController, animated: true, completion: nil)
	}
	
	func editAction(indexPath: IndexPath) {
		if runningOn == "Mac" {
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add Device Mac") as! AddDeviceMacHostingView
			vc.shouldEdit = true
			vc.indexToEdit = indexPath.section
			
			vc.modalPresentationStyle = .formSheet
			vc.preferredContentSize = CGSize(width: 350, height: 600)
			present(vc, animated: false)
		} else {
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add Device") as! NewDeviceTableViewController
			vc.shouldEdit = true
			vc.indexToEdit = indexPath.section
			
			let nav = UINavigationController(rootViewController: vc)
			nav.modalPresentationStyle = .formSheet
			
			present(nav, animated: false)
		}
	}	
}

class DeviceListCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var deviceImage: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		if runningOn == "Mac" {
			deviceImage.layer.cornerCurve = .continuous
			deviceImage.layer.cornerRadius = 5
			deviceImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
			deviceImage.layer.borderColor = UIColor.separator.cgColor
			deviceImage.layer.borderWidth = 1
		}
		
		let customBackgroundView = UIView()
		if runningOn != "Mac" {
			if self.backgroundColor == .none || self.backgroundColor == .clear {
				customBackgroundView.backgroundColor = .secondarySystemGroupedBackground
			} else {
				customBackgroundView.backgroundColor = self.backgroundColor
			}
		}
		customBackgroundView.layer.cornerCurve = .continuous
		customBackgroundView.layer.cornerRadius = runningOn == "Mac" ? 5 : 10
		if runningOn == "Mac" {
			if self.backgroundColor == .none || self.backgroundColor == .clear || self.backgroundColor == .secondarySystemGroupedBackground {
				customBackgroundView.backgroundColor = .separator.withAlphaComponent(0.05)
				customBackgroundView.layer.borderColor = UIColor.separator.cgColor
				customBackgroundView.layer.borderWidth = 1
			} else {
				customBackgroundView.backgroundColor = self.backgroundColor
			}
		}
		customBackgroundView.clipsToBounds = true
		self.backgroundView = customBackgroundView
		self.backgroundColor = .clear
		
		let selectedBackView = UIView()
		selectedBackView.layer.cornerCurve = .continuous
		selectedBackView.layer.cornerRadius = runningOn == "Mac" ? 5 : 10
		selectedBackView.frame = self.frame
		if runningOn == "Mac" {
			selectedBackView.backgroundColor = .separator.withAlphaComponent(0.1)
			selectedBackView.layer.borderColor = UIColor.separator.cgColor
			selectedBackView.layer.borderWidth = 1
		} else {
			selectedBackView.backgroundColor = .systemGray3
		}
		selectedBackView.clipsToBounds = true
		self.selectedBackgroundView = selectedBackView
	}
}


extension UIViewController {
	var viewIsCompact: Bool {
		return traitCollection.horizontalSizeClass == .compact
	}
}
