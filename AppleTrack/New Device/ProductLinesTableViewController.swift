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
		
		if runningOn != "Mac" {
			let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
			blurView.frame = self.view.bounds
			tableView.backgroundView = blurView
		}
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
			DispatchQueue.main.async { [self] in
				let menuButton = UIButton()
				menuButton.preferredBehavioralStyle = .pad
				menuButton.alpha = 1
				menuButton.setTitle("", for: .normal)
				menuButton.menu = getMenu(forProduct: mainProductLines[indexPath.section])
				menuButton.showsMenuAsPrimaryAction = true
				
				cell.contentView.addSubview(menuButton)
				
				menuButton.translatesAutoresizingMaskIntoConstraints = false
				let constraints = [
					menuButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0),
					menuButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0),
					menuButton.trailingAnchor.constraint(greaterThanOrEqualTo: cell.contentView.trailingAnchor, constant: 0),
					menuButton.leadingAnchor.constraint(greaterThanOrEqualTo: cell.contentView.leadingAnchor, constant: 0),
					menuButton.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
				]
				NSLayoutConstraint.activate(constraints)
			}
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
			setProductLine(withValue: lineToUse)
		}
	}
	
	func saveCustom(withValue: String) {
		setProductLine(withValue: withValue)
	}
	
	func setProductLine(withValue: String) {
		self.sourceView.productLine = withValue
		self.sourceView.productLineButton.setTitle(withValue, for: .normal)
		if self.sourceView.modelNameField.text == "" {
			self.sourceView.modelNameField.text = withValue + " "
		}
		DispatchQueue.main.async {
			self.dismiss(animated: true)
		}
	}
	
	@IBAction func dismiss(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
	func generateMenuActions(forItems: [String]) -> [UIAction] {
		var toReturn: [UIAction] = []
		for product in forItems {
			toReturn.append(
				UIAction(title: product, image: nil, handler: { (_) in
					self.setProductLine(withValue: product)
				})
			)
		}
		return toReturn
	}
	
	func getMenu(forProduct: String) -> UIMenu {
		let productName = forProduct.replacingOccurrences(of: "MORE", with: "")
		switch forProduct {
		case "MacMORE":
			let laptopsMenu = UIMenu(title: "Laptops", subtitle: "Laptops", options: .displayInline, children: generateMenuActions(forItems: macLaptopProductLines)) 
			let desktopsMenu = UIMenu(title: "Desktops", subtitle: "Desktops", options: .displayInline, children: generateMenuActions(forItems: macDesktopProductLines)) 
			return UIMenu(title: "Options for " + productName, children: [laptopsMenu, desktopsMenu])
			
		case "iPodMORE":
			return UIMenu(title: "Options for " + productName, children: generateMenuActions(forItems: iPodProductLines))
			
		case "iPadMORE":
			return UIMenu(title: "Options for " + productName, children: generateMenuActions(forItems: iPadProductLines))
			
		default:
			return UIMenu(title: "Error", children: generateMenuActions(forItems: ["Dismiss"]))
		}
	}
	
}
