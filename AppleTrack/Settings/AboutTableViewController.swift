
//
//  AboutTableViewController.swift
//  School Assistant
//
//  Created by Dylan McDonald on 6/14/20.
//  Copyright © 2020 Dylan McDonald. All rights reserved.
//

import UIKit

import SafariServices

class AboutTableViewController: UITableViewController, SFSafariViewControllerDelegate {
	
    override func viewWillAppear(_ animated: Bool) {
//        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
//            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
//        }
        
    }
    
    @objc func goBack(_ sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
	@IBAction func dismiss(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.navigationBar.prefersLargeTitles = false
		let label = UILabel()
		label.textColor = .label
		label.text = "About"
		self.title = ""
		label.font = UIFont.systemFont(ofSize: (runningOn == "Mac") ? 17 : 25, weight: .bold)
		self.navigationItem.leftBarButtonItems = [UIBarButtonItem.init(customView: label)]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let urlString = "https://sunapps.org"
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
               
                vc.delegate = self
                present(vc, animated: true)
            }
        }
        
        if indexPath.section == 4 {
            
            let urlString = "https://sunapps.org/privacypolicy"
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
                
                vc.delegate = self
                present(vc, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
		
		if indexPath.section == 6 {
			let alertController = UIAlertController(title: "Are you sure?", message: "This will add sample data to the app. This is not intended for general users. You should delete existing entries before doing this.", preferredStyle: .alert)
			
			let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
			}
			
			let action1 = UIAlertAction(title: "Apply Sample Data", style: .destructive) { (action:UIAlertAction) in
				let dateFormatter = DateFormatter()
				dateFormatter.dateStyle = .long
				let sampleImage = UIImage(named: "Fallback Image")!.pngData()!
//				createNewSavedDevice(productLine: "Apple TV", modelName: "Apple TV 4K", announcementDate: dateFormatter.date(from: "September 12, 2017")!, releaseDate: Date(), purchaseDate: Date(), color: "Black", capacity: "32 GB", serialNumber: "XXXXXXXXXX", notes: "", imageData: sampleImage)
				createNewSavedDevice(productLine: "MacBook Pro", modelName: "MacBook Pro (16-inch, 2021)", announcementDate: dateFormatter.date(from: "October 18, 2021")!, releaseDate: Date(), purchaseDate: Date(), color: "Space Gray", capacity: "1 TB", serialNumber: "XXXXXXXXXX", notes: "", imageData: sampleImage)
				createNewSavedDevice(productLine: "MacBook Pro", modelName: "MacBook Pro (15-inch, 2017)", announcementDate: dateFormatter.date(from: "June 5, 2017")!, releaseDate: Date(), purchaseDate: Date(), color: "Space Gray", capacity: "512 GB", serialNumber: "XXXXXXXXXX", notes: "", imageData: sampleImage)
				createNewSavedDevice(productLine: "iPhone", modelName: "iPhone 13 Pro Max", announcementDate: dateFormatter.date(from: "September 14, 2021")!, releaseDate: Date(), purchaseDate: Date(), color: "Sierra Blue", capacity: "512 GB", serialNumber: "XXXXXXXXXX", notes: "", imageData: sampleImage)
				createNewSavedDevice(productLine: "iPhone", modelName: "iPhone 6", announcementDate: dateFormatter.date(from: "September 9, 2014")!, releaseDate: Date(), purchaseDate: Date(), color: "Silver", capacity: "16 GB", serialNumber: "XXXXXXXXXX", notes: "", imageData: sampleImage)
				createNewSavedDevice(productLine: "iPhone", modelName: "iPhone", announcementDate: dateFormatter.date(from: "January 7, 2007")!, releaseDate: Date(), purchaseDate: Date(), color: "Silver", capacity: "4 GB", serialNumber: "XXXXXXXXXX", notes: "", imageData: sampleImage)
				createNewSavedDevice(productLine: "iPod classic", modelName: "iPod (5th Generation)", announcementDate: dateFormatter.date(from: "October 12, 2005")!, releaseDate: Date(), purchaseDate: Date(), color: "White", capacity: "80 GB", serialNumber: "XXXXXXXXXX", notes: "", imageData: sampleImage)
				createNewSavedDevice(productLine: "iPod classic", modelName: "iPod (3rd Generation)", announcementDate: dateFormatter.date(from: "July 14, 2004")!, releaseDate: Date(), purchaseDate: Date(), color: "White", capacity: "40 GB", serialNumber: "XXXXXXXXXX", notes: "", imageData: sampleImage)
				createNewSavedDevice(productLine: "iPad mini", modelName: "iPad mini (6th Generation)", announcementDate: dateFormatter.date(from: "September 14, 2021")!, releaseDate: Date(), purchaseDate: Date(), color: "Purple", capacity: "256 GB", serialNumber: "XXXXXXXXXX", notes: "", imageData: sampleImage)
				createNewSavedDevice(productLine: "iPad mini", modelName: "iPad mini", announcementDate: dateFormatter.date(from: "October 23, 2012")!, releaseDate: Date(), purchaseDate: Date(), color: "Purple", capacity: "256 GB", serialNumber: "XXXXXXXXXX", notes: "", imageData: sampleImage)
				
			}
			
			alertController.addAction(action1)
			alertController.addAction(action2)
			alertController.actions[0].setValue(UIColor(named: "AccentColor")!, forKey: "titleTextColor")
			alertController.view.tintColor = UIColor(named: "AccentColor")!
			self.present(alertController, animated: true, completion: nil)
		}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        #if targetEnvironment(macCatalyst)
//        updateTitlebarSubtitle(with: "About", session: (self.view.window?.windowScene?.session)!)
        #endif
    }
    
}
