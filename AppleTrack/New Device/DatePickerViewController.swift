//
//  DatePickerViewController.swift
//  AppleTrack
//
//  Created by Dylan McDonald on 7/25/22.
//

import UIKit

class DatePickerViewController: UIViewController {
	
	@IBOutlet weak var datePicker: UIDatePicker!
	
	var dateToSet: Date = Date()
	var sourceView: NewDeviceTableViewController!
	var dateCategory: String = "Announcement"

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationController?.navigationBar.prefersLargeTitles = false
		let label = UILabel()
		label.textColor = .label
		label.text = "Select Date"
		self.title = ""
		label.font = UIFont.systemFont(ofSize: (runningOn == "Mac") ? 17 : 25, weight: .bold)
		self.navigationItem.leftBarButtonItems = [UIBarButtonItem.init(customView: label)]
		
		self.view.backgroundColor = .clear
		
		datePicker.date = dateToSet
		
		self.preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

	override func viewWillDisappear(_ animated: Bool) {
		sourceView.setDate(with: datePicker.date, forCategory: dateCategory)
	}

	@IBAction func dismiss(_ sender: Any) {
		self.dismiss(animated: true)
	}
}
