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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.isNavigationBarHidden = true
		
		backButtonBlur.layer.cornerRadius = 35 / 2
		backButtonBlur.clipsToBounds = true
		
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
		
		if runningOn == "Mac" {
			self.view.backgroundColor = .clear
		}
		
		tableView.allowsFocus = false
	}
	
	@IBAction func back(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
}
