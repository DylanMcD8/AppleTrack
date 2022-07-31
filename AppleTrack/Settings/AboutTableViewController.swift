
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        #if targetEnvironment(macCatalyst)
//        updateTitlebarSubtitle(with: "About", session: (self.view.window?.windowScene?.session)!)
        #endif
    }
    
}
