//
//  MainViewController.swift
//  AppleTrack
//
//  Created by Dylan McDonald on 7/22/22.
//

import UIKit

class MainViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		if runningOn == "Mac" {
			self.view.backgroundColor = .clear
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(showBoot(_:)), name: NSNotification.Name(rawValue: "ShowBoot"), object: nil)
		
		if needsBoot {
//			if runningOn != "Mac" {
				let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Boot Screen")
				vc.modalPresentationStyle = .fullScreen
				vc.modalTransitionStyle = .crossDissolve
				present(vc, animated: false)
				needsBoot = false
//			}
		}
    }
    

	@objc func showBoot(_ notification: Notification) {
		if needsBoot {
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Boot Screen")
			vc.modalPresentationStyle = .fullScreen
			vc.modalTransitionStyle = .crossDissolve
			present(vc, animated: false)
			needsBoot = false
		}
	}


}
