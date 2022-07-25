//
//  Standard Views.swift
//  AppleTrack
//
//  Created by Dylan McDonald on 7/21/22.
//

import UIKit

class StandardCell: UITableViewCell {
	override func awakeFromNib() {
		super.awakeFromNib()
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

class TintedImage: UIImageView {
	override func layoutSubviews() {
		self.tintColor = manualAccentColor()
		let config = UIImage.SymbolConfiguration(hierarchicalColor: manualAccentColor())
		self.image = self.image?.applyingSymbolConfiguration(config)
	}
	
	override func tintColorDidChange() {
		self.tintColor = manualAccentColor()
		let config = UIImage.SymbolConfiguration(hierarchicalColor: manualAccentColor())
		self.image = self.image?.applyingSymbolConfiguration(config)
	}
}

class grayButton: UIButton {
	override func draw(_ rect: CGRect) {
		let title = self.configuration?.title ?? ""
		let subtitle = self.configuration?.subtitle ?? ""
		let image = self.configuration?.image ?? .none
		let imagePlacement = self.configuration?.imagePlacement ?? .trailing
		let imagePadding = self.configuration?.imagePadding ?? 5
		
		if runningOn == "Mac" {
			self.configuration = UIButton.Configuration.plain()
			self.configuration?.title = title
			self.configuration?.subtitle = subtitle
			self.configuration?.imagePlacement = imagePlacement
			self.configuration?.imagePadding = imagePadding
			
			if image != nil {
				self.configuration?.image = image
			}
		}
	}
	
	override func tintColorDidChange() {
		self.tintColor = manualAccentColor()
	}
}

class TintedButton: UIButton {
	override func tintColorDidChange() {
		let title = self.configuration?.title ?? ""
		let subtitle = self.configuration?.subtitle ?? ""
		let image = self.configuration?.image ?? .none
		let imagePlacement = self.configuration?.imagePlacement ?? .trailing
		let imagePadding = self.configuration?.imagePadding ?? 5
		
		if runningOn == "Mac" {
			self.configuration = UIButton.Configuration.tinted()
			self.configuration?.title = title
			self.configuration?.subtitle = subtitle
			self.configuration?.imagePlacement = imagePlacement
			self.configuration?.imagePadding = imagePadding
			
			if image != nil {
				self.configuration?.image = image
			}
		}
		self.tintColor = manualAccentColor()
	}
}

func manualAccentColor() -> UIColor {
	var toReturn: UIColor = UIColor(named: "AccentColor")!
	if !isAccentMulticolor() {
		toReturn = UIColor(named: macAccentColorName()) ?? UIColor(named: "AccentColor")!
	}
	return toReturn
}

func isAccentMulticolor() -> Bool {
	var toReturn = false
	if UserDefaults.standard.bool(forKey: "NSColorSimulateHardwareAccent") {
		if UserDefaults.standard.string(forKey: "AppleAccentColor") ?? "No color returned" == "-2" {
			toReturn = true
		}
	} else if UserDefaults.standard.object(forKey: "AppleAccentColor") == nil {
		toReturn = true
	}
	return toReturn
}

func macAccentColorName() -> String {
	var toReturn: String = ""
	if UserDefaults.standard.bool(forKey: "NSColorSimulateHardwareAccent") {
		if UserDefaults.standard.string(forKey: "AppleAccentColor") ?? "No color returned" == "-2" {
			toReturn = "Multicolor"
		}
	} else if UserDefaults.standard.object(forKey: "AppleAccentColor") == nil {
		toReturn = "Multicolor"
	}
	
	if toReturn != "Multicolor" {
		if UserDefaults.standard.bool(forKey: "NSColorSimulateHardwareAccent") && UserDefaults.standard.object(forKey: "AppleAccentColor") == nil {
			
			switch UserDefaults.standard.string(forKey: "NSColorSimulatedHardwareEnclosureNumber") ?? "No iMac color returned" {
			case "3":
				toReturn = "iMac Yellow 3"
			case "4":
				toReturn = "iMac Green 4"
			case "5":
				toReturn = "iMac Blue 5"
			case "6":
				toReturn = "iMac Pink 6"
			case "7":
				toReturn = "iMac Purple 7"
			case "8":
				toReturn = "iMac Orange 8"
			default:
				toReturn = "No iMac color returned"
			}
			
		} else {
			// This runs if the Mac is not an M1 iMac or an M1 iMac is using the standard color options.
			
			switch UserDefaults.standard.string(forKey: "AppleAccentColor") ?? "No color returned" {
			case "4":
				toReturn = "System Blue 4"
			case "5":
				toReturn = "System Purple 5"
			case "6":
				toReturn = "System Pink 6"
			case "0":
				toReturn = "System Red 0"
			case "1":
				toReturn = "System Orange 1"
			case "2":
				toReturn = "System Yellow 2"
			case "3":
				toReturn = "System Green 3"
			case "-1":
				toReturn = "System Graphite -1"
			case "-2":
				toReturn = "Multicolor"
			default:
				toReturn = "No regular color returned"
			}
		}
	}
	
	return toReturn
}


let cornerRadius: CGFloat = runningOn == "Mac" ? 10 : 10

class BlurredStandardcell: UITableViewCell {
	override func awakeFromNib() {
		if runningOn == "Mac" {
			super.awakeFromNib()
			self.backgroundColor = .clear
			let customBackgroundView = UIView()
			customBackgroundView.backgroundColor = .secondarySystemGroupedBackground
			customBackgroundView.layer.cornerCurve = .continuous
			customBackgroundView.layer.cornerRadius = cornerRadius
			customBackgroundView.clipsToBounds = true
			if runningOn == "Mac" {
				if self.backgroundColor == .none || self.backgroundColor == .clear || self.backgroundColor == .secondarySystemGroupedBackground {
					customBackgroundView.backgroundColor = .separator.withAlphaComponent(0.05)
				} else {
					customBackgroundView.backgroundColor = self.backgroundColor
				}
				customBackgroundView.layer.borderColor = UIColor.separator.cgColor
				customBackgroundView.layer.borderWidth = 1
			} else {
				customBackgroundView.backgroundColor = UIColor(named: "Cell on Blur")!
			}
			self.backgroundView = customBackgroundView
			
			let selectedBackView = UIView()
			selectedBackView.layer.cornerCurve = .continuous
			selectedBackView.layer.cornerRadius = cornerRadius
			selectedBackView.frame = self.frame
			if runningOn == "Mac" {
				selectedBackView.backgroundColor = .separator.withAlphaComponent(0.1)
				selectedBackView.layer.borderColor = UIColor.separator.cgColor
				selectedBackView.layer.borderWidth = 1
			} else {
				selectedBackView.backgroundColor = UIColor(named: "Cell on Blur Secondary")!
			}
			selectedBackView.clipsToBounds = true
			self.selectedBackgroundView = selectedBackView
		}
	}
}

final class SheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
	
	
	var shouldShowGrabber: Bool = false
	
	func presentationController(
		forPresented presented: UIViewController,
		presenting: UIViewController?,
		source: UIViewController
	) -> UIPresentationController? {
		let controller = UISheetPresentationController(presentedViewController: presented, presenting: presenting)
		//        controller.preferredCornerRadius = 30
		controller.prefersScrollingExpandsWhenScrolledToEdge = true
		if source.viewIsCompact {
			controller.detents = [.medium(), .large()]
			//            controller.largestUndimmedDetentIdentifier = .medium
		} else {
			controller.detents = [.large()]
		}
		if runningOn == "Mac" {
			controller.prefersGrabberVisible = false
		} else {
			controller.prefersGrabberVisible = shouldShowGrabber
		}
		return controller
	}
}
