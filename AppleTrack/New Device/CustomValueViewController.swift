//
//  CustomValueViewController.swift
//  AppleTrack
//
//  Created by Dylan McDonald on 7/24/22.
//

import UIKit

class CustomValueViewController: UIViewController {
	
	var sourceView: ProductLinesTableViewController!
	
	@IBOutlet weak var customValueField: UITextField!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

		if runningOn != "Mac" {
			self.navigationController?.navigationBar.prefersLargeTitles = false
			let label = UILabel()
			label.textColor = .label
			label.text = "Custom Value"
			self.title = ""
			label.font = UIFont.systemFont(ofSize: (runningOn == "Mac") ? 17 : 25, weight: .bold)
			self.navigationItem.leftBarButtonItems = [UIBarButtonItem.init(customView: label)]
		} else {
			self.view.backgroundColor = .clear
		}
		
		customValueField.becomeFirstResponder()
		
		self.preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
	@IBAction func cancel(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
	@IBAction func save(_ sender: Any) {
		if customValueField.text != "" {
			self.sourceView.saveCustom(withValue: customValueField.text ?? "")
			self.dismiss(animated: true)
		} else {
			let alertController = UIAlertController(title: "Enter a Value", message: "You must first enter a product line name in the field before saving.", preferredStyle: .alert)
			
			let action2 = UIAlertAction(title: "Dismiss", style: .cancel) { (action:UIAlertAction) in
			}
			alertController.addAction(action2)
			self.present(alertController, animated: true, completion: nil)
		}
	}
	
}
