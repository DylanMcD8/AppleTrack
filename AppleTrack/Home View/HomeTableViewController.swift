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
		if runningOn == "Mac" {
			self.navigationController?.isNavigationBarHidden = true
			self.view.backgroundColor = .clear
		} else {
			self.navigationController?.view.tintColor = self.view.tintColor
			self.navigationController?.isNavigationBarHidden = false
			self.navigationController?.navigationBar.prefersLargeTitles = true
			self.navigationController?.navigationBar.sizeToFit()
		}
		
		tableView.allowsFocus = false
		
		NotificationCenter.default.addObserver(self, selector: #selector(UpdateSavedDevices(_:)), name: NSNotification.Name(rawValue: "UpdateSavedDevices"), object: nil)
    }
	
	@objc func UpdateSavedDevices(_ notification: Notification) {
		tableView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		if runningOn == "Mac" {
			self.navigationController?.isNavigationBarHidden = true
			self.view.backgroundColor = .clear
		} else {
			self.navigationController?.view.tintColor = self.view.tintColor
			self.navigationController?.isNavigationBarHidden = false
			self.navigationController?.navigationBar.prefersLargeTitles = true
			self.navigationController?.navigationBar.sizeToFit()
		}
		
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
	
	@IBAction func showAbout(_ sender: Any) {
		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "About Nav")
		vc.modalPresentationStyle = .formSheet
		vc.preferredContentSize = CGSize(width: 350, height: 610)
		present(vc, animated: true)
	}
	
	@IBAction func newDevice(_ sender: Any) {
		if runningOn == "Mac" {
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add Device Mac") as! AddDeviceMacHostingView
			vc.shouldEdit = false
			
			vc.modalPresentationStyle = .formSheet
			vc.preferredContentSize = CGSize(width: 350, height: 600)
			present(vc, animated: true)
		}
	}
	
	@IBAction func refreshData(_ sender: Any) {
		getSavedDevicesData()
	}
	
	func updateCellColors() {
		for index in 0...tableView.numberOfSections - 1 {
			let cell = tableView.cellForRow(at: [index,0]) as! DeviceListCell
			cell.index = index
			UIView.animate(withDuration : 0.3) {
				cell.customBackgroundView.backgroundColor = self.appleColor(forIndex: index, useDark: (runningOn != "Mac"))
			}
		}
	}
	
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return SavedProductLines.uniqued().count 
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let uniqueProductLines = SavedProductLines.uniqued()
		return SavedProductLines.filter{$0 == uniqueProductLines[section]}.count
	}
	
	var lastProductLine = ""
	var indexForCells: Int = 0
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let index = indexPath.section // - 1
		let index = indexForCells
		
		var cell: UITableViewCell!
		
		if deviceProductLine(forIndex: index) != lastProductLine {
			cell = self.tableView.dequeueReusableCell(withIdentifier: "title cell", for: indexPath) as! SectionTitleCell
			let cellToUse = cell as! SectionTitleCell
			cellToUse.titleLabel.text = deviceProductLine(forIndex: index)
			cellToUse.iconImageView.image = productLineImage(forLine: deviceProductLine(forIndex: index))
		} else {
			cell = self.tableView.dequeueReusableCell(withIdentifier: "main cell", for: indexPath) as! DeviceListCell
			let cellToUse = cell as! DeviceListCell
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy"
			let releaseYear = dateFormatter.string(from: deviceReleaseDate(forIndex: index))
			cellToUse.titleLabel.text = deviceModelName(forIndex: index)
			cellToUse.titleLabel.textColor = .white
			cellToUse.subtitleLabel.text = deviceColor(forIndex: index) + " • " + releaseYear
			cellToUse.subtitleLabel.textColor = .white.withAlphaComponent(0.6)
			cellToUse.deviceImage.image = deviceImage(forIndex: index)
			
			cellToUse.index = index
			
			if runningOn == "Mac" {
				cellToUse.customBackgroundView.backgroundColor = appleColor(forIndex: index, useDark: false).withAlphaComponent(0.3)
			} else {
				cellToUse.customBackgroundView.backgroundColor = appleColor(forIndex: index, useDark: true)
			}
			
			cellToUse.deviceImage.layer.shouldRasterize = true
			if let window = self.view.window {
				cellToUse.deviceImage.layer.rasterizationScale = window.screen.scale
			} else {
				cellToUse.deviceImage.layer.rasterizationScale = 3
			}
			indexForCells = indexForCells + 1
		}
		
		lastProductLine = deviceProductLine(forIndex: index)
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
			if let splitViewController = self.splitViewController {
				if splitViewController.viewIsCompact {
					self.show(vc, sender: nil)
				} else {
					self.showDetailViewController(vc, sender: nil)
				}
			} else {
				self.show(vc, sender: nil)
			}
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
		
		let menu = UIMenu(title: "", children: [edit, delete])
		if #available(iOS 16.0, *) {
			menu.preferredElementSize = .medium
		}
		
		return menu
	}
	
	func deleteAction(indexPath: IndexPath) {
		let alertController = UIAlertController(title: "Are you sure?", message: "This will permanently remove this device from AppleTrack.", preferredStyle: .alert)
		
		let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
		}
		
		let action1 = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
			deleteAllDataForSavedDevice(atIndex: indexPath.section, shouldReload: false)
			self.tableView.deleteSections([indexPath.section], with: .middle)
			self.updateCellColors()
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
			present(vc, animated: true)
		} else {
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add Device") as! NewDeviceTableViewController
			vc.shouldEdit = true
			vc.indexToEdit = indexPath.section
			
			let nav = UINavigationController(rootViewController: vc)
			nav.modalPresentationStyle = .formSheet
			
			present(nav, animated: true)
		}
	}	
	
	func productLineImage(forLine: String) -> UIImage {
		var symbolName: String = ""
		switch forLine {
		case "Apple Watch":
			symbolName = "watch"
		case "iPhone":
			symbolName = "iphone"
		default:
			break
		}
		return UIImage(systemName: symbolName) ?? UIImage(systemName: "applelogo")!
	}
}

class DeviceListCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var deviceImage: UIImageView!
	
	var index: Int = 0
	
	var customBackgroundView = UIView()
	var selectedBackView = UIView()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		if runningOn == "Mac" {
			deviceImage.layer.cornerCurve = .continuous
			deviceImage.layer.cornerRadius = 9.5
			deviceImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
			deviceImage.layer.borderColor = UIColor.separator.cgColor
			deviceImage.layer.borderWidth = 1
		} else {
			deviceImage.layer.cornerCurve = .continuous
			deviceImage.layer.cornerRadius = 19.5
			
			deviceImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
		}
		
		if runningOn != "Mac" {
			if self.backgroundColor == .none || self.backgroundColor == .clear || self.backgroundColor == .secondarySystemGroupedBackground {
//				customBackgroundView.backgroundColor = .secondarySystemGroupedBackground
				customBackgroundView.backgroundColor = appleColor(forIndex: index, useDark: true)
			} else {
				customBackgroundView.backgroundColor = self.backgroundColor
			}
		}
		customBackgroundView.layer.cornerCurve = .continuous
		customBackgroundView.layer.cornerRadius = runningOn == "Mac" ? 10 : 20
		if runningOn == "Mac" {
			if self.backgroundColor == .none || self.backgroundColor == .clear || self.backgroundColor == .secondarySystemGroupedBackground {
//				customBackgroundView.backgroundColor = .separator.withAlphaComponent(0.05)
				appleColor(forIndex: index, useDark: false).withAlphaComponent(0.3)
				customBackgroundView.layer.borderColor = UIColor.separator.cgColor
				customBackgroundView.layer.borderWidth = 1
			} else {
				customBackgroundView.backgroundColor = self.backgroundColor
			}
		}
		customBackgroundView.clipsToBounds = true
		self.backgroundView = customBackgroundView
		self.backgroundColor = .clear
		
		selectedBackView.layer.cornerCurve = .continuous
		selectedBackView.layer.cornerRadius = runningOn == "Mac" ? 10 : 20
		selectedBackView.frame = self.frame
		if runningOn == "Mac" {
			selectedBackView.backgroundColor = .separator.withAlphaComponent(0.1)
			selectedBackView.layer.borderColor = UIColor.separator.cgColor
			selectedBackView.layer.borderWidth = 1
		} else {
//			selectedBackView.backgroundColor = .systemGray3
			selectedBackView.backgroundColor = .label.withAlphaComponent(0.3)
		}
		selectedBackView.clipsToBounds = true
		self.selectedBackgroundView = selectedBackView
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
			if runningOn != "Mac" {
				if self.backgroundColor == .none || self.backgroundColor == .clear || self.backgroundColor == .secondarySystemGroupedBackground {
					//				customBackgroundView.backgroundColor = .secondarySystemGroupedBackground
				
					customBackgroundView.backgroundColor = appleColor(forIndex: index, useDark: true)
					
				} else {
					customBackgroundView.backgroundColor = self.backgroundColor
				}
				selectedBackView.backgroundColor = .label.withAlphaComponent(0.3)
			} else {
				if self.backgroundColor == .none || self.backgroundColor == .clear || self.backgroundColor == .secondarySystemGroupedBackground {
					//				customBackgroundView.backgroundColor = .separator.withAlphaComponent(0.05)
					appleColor(forIndex: index, useDark: false).withAlphaComponent(0.3)
					customBackgroundView.layer.borderColor = UIColor.separator.cgColor
					customBackgroundView.layer.borderWidth = 1
				} else {
					customBackgroundView.backgroundColor = self.backgroundColor
				}
			}
		}
	}
}


class SectionTitleCell: UITableViewCell {
	
	@IBOutlet weak var iconImageView: TintedImage!
	@IBOutlet weak var titleLabel: UILabel!
	
}

extension Sequence where Element: Hashable {
	func uniqued() -> [Element] {
		var set = Set<Element>()
		return filter { set.insert($0).inserted }
	}
}

extension UIViewController {
	var viewIsCompact: Bool {
		return traitCollection.horizontalSizeClass == .compact
	}
}

extension UIView {
	func appleColor(forIndex: Int, useDark: Bool) -> UIColor {
		var numberToUse: Int = 0
		if forIndex == 6 {
			numberToUse = 0
		} else {
			numberToUse = (forIndex % 6)
		}
		if useDark {
			if traitCollection.userInterfaceStyle == .dark {
				return UIColor(named: "LabelInvert")!.add(overlay: UIColor(named: rainbowAppleColors[numberToUse])!.withAlphaComponent(0.7))
			} else {
				return UIColor(named: rainbowAppleColors[numberToUse])!
			}
		} else {
			return UIColor(named: rainbowAppleColors[numberToUse])!
		}
	}
}

extension UITableViewController {
	func appleColor(forIndex: Int, useDark: Bool) -> UIColor {
		var numberToUse: Int = 0
		if forIndex == 6 {
			numberToUse = 0
		} else {
			numberToUse = (forIndex % 6)
		}
		if useDark {
			if traitCollection.userInterfaceStyle == .dark {
				return UIColor(named: "LabelInvert")!.add(overlay: UIColor(named: rainbowAppleColors[numberToUse])!.withAlphaComponent(0.7))
			} else {
				return UIColor(named: rainbowAppleColors[numberToUse])!
			}
		} else {
			return UIColor(named: rainbowAppleColors[numberToUse])!
		}
	}
}
