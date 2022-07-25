//
//  ProductLinesTableViewController.swift
//  AppleTrack
//
//  Created by Dylan McDonald on 7/24/22.
//

import UIKit

class ProductLinesTableViewController: UITableViewController {

	var sourceView: NewDeviceTableViewController!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.navigationBar.prefersLargeTitles = false
		let label = UILabel()
		label.textColor = .label
		label.text = "Product Lines"
		self.title = ""
		label.font = UIFont.systemFont(ofSize: (runningOn == "Mac") ? 17 : 25, weight: .bold)
		self.navigationItem.leftBarButtonItems = [UIBarButtonItem.init(customView: label)]
		
		self.view.backgroundColor = .clear
    }
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return mainProductLines.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "main cell", for: indexPath) 
		
		if mainProductLines[indexPath.section].contains("MORE") {
			cell.accessoryType = .disclosureIndicator
		} else if mainProductLines[indexPath.section].contains("CUSTOM") {
			cell.accessoryType = .disclosureIndicator
		} 
		
		cell.textLabel?.text = mainProductLines[indexPath.section].replacingOccurrences(of: "MORE", with: "").replacingOccurrences(of: "CUSTOM", with: "")
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if mainProductLines[indexPath.section].contains("MORE") {
			
		} else if mainProductLines[indexPath.section].contains("CUSTOM") {
			let viewID = runningOn == "Mac" ? "Custom Value Mac" : "Custom Value"
			let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewID) as! CustomValueViewController
			view.sourceView = self
			view.modalPresentationStyle = .formSheet
			present(view, animated: false)
		} else {
			let lineToUse = mainProductLines[indexPath.section].replacingOccurrences(of: "MORE", with: "").replacingOccurrences(of: "CUSTOM", with: "")
			self.sourceView.productLine = lineToUse
			self.sourceView.productLineButton.setTitle(lineToUse, for: .normal)
			dismiss(animated: true)
		}
	}
	
	func saveCustom(withValue: String) {
		self.sourceView.productLine = withValue
		self.sourceView.productLineButton.setTitle(withValue, for: .normal)
		DispatchQueue.main.async {
			self.dismiss(animated: true)
		}
	}
	
	@IBAction func dismiss(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
}
