//
//  CGASceneDelegate+NSToolbar.swift
//  Catalyst Grid App
//
//  Created by Steven Troughton-Smith on 07/10/2021.
//  
//

import UIKit

#if targetEnvironment(macCatalyst)
import AppKit

extension NSToolbarItem.Identifier {
	static let back = NSToolbarItem.Identifier("com.wordler.back")
    static let reload = NSToolbarItem.Identifier("com.wordler.reload")
	static let refresh = NSToolbarItem.Identifier("com.wordler.refresh")
    static let add = NSToolbarItem.Identifier("com.wordler.add")
	static let sortOptions = NSToolbarItem.Identifier("com.appletrack.sortOptions")
//    static let close = NSToolbarItem.Identifier("com.example.close")
}

func hideTitlebar(session: UISceneSession) {
	if let windowScene = session.scene as? UIWindowScene {
		if let titlebar = windowScene.titlebar {
			titlebar.toolbar = nil
			//					let toolbar = NSToolbar(identifier: "main")
			//					titlebar.toolbar = toolbar
			//					windowScene.title = "AppleTrack"
			titlebar.titleVisibility = .hidden
			//					toolbar.delegate = HomeToolbarDelegate()
		}
	}

}

func updateTitlebarTitle(with: String, session: UISceneSession) {
    let windowScene = session.scene as! UIWindowScene
//    if runningOn == "iPad" {
//        windowScene.subtitle = with
//    } else if runningOn == "Mac" {
        windowScene.title = with
//    }
}
func updateTitlebarSubtitle(with: String, session: UISceneSession) {
    let windowScene = session.scene as! UIWindowScene
//    if runningOn == "Mac" {
        windowScene.subtitle = with
//    }
}

func updateTitleBar(withDelegate: NSToolbarDelegate, withTitle: String, withSubtitle: String, iconMode: NSToolbar.DisplayMode, sender: UIViewController, session: UISceneSession) {
    var toolbarDelegate: NSToolbarDelegate?
    toolbarDelegate = withDelegate
    
//    guard let session = sender.view.window?.windowScene?.session else { print("No session"); return }
    let windowScene = session.scene as! UIWindowScene
    
//    let windowScene = UIApplication.shared.keyWindow?.windowScene
    
    windowScene.title = withTitle
    windowScene.subtitle = withSubtitle
    
    
    let toolbar = NSToolbar(identifier: "main")
    toolbar.delegate = toolbarDelegate
    toolbar.displayMode = iconMode
    toolbar.allowsUserCustomization = false
    // Enabling this breaks the whole app
//    toolbar.autosavesConfiguration = true
    toolbar.showsBaselineSeparator = false

    if let titlebar = windowScene.titlebar {
        titlebar.toolbar = toolbar
        titlebar.toolbarStyle = .unified
        titlebar.separatorStyle = .none
    }

    sender.navigationController?.isNavigationBarHidden = true
}

class SettingsToolbarDelegate: NSObject {
}

extension SettingsToolbarDelegate: NSToolbarDelegate {
    
	func toolbarItems() -> [NSToolbarItem.Identifier] {
        return [.back]
	}
	
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItems()
	}
	
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItems()
	}
	
	func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		if itemIdentifier == .back {
			
			let barItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: NSSelectorFromString("goBack:"))
			/*
			 NSToolbarItemGroup does not auto-enable/disable buttons based on the responder chain, so we need an NSToolbarItem here instead
			 */
			
			let item = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barItem)
			
			item.label = "Back"
			item.toolTip = "Back"
			item.isBordered = true
			item.isNavigational = true
            item.autovalidates = false
			
			return item
		}

		
		return NSToolbarItem(itemIdentifier: itemIdentifier)
	}
}



extension NSToolbarItem.Identifier {
    static let close = NSToolbarItem.Identifier("com.sunapps.wordle-assistant.close")
    static let openSettings = NSToolbarItem.Identifier("com.sunapps.wordle-assistant.openSettings")
}
class HomeToolbarDelegate: NSObject {
}

extension HomeToolbarDelegate: NSToolbarDelegate {
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        let identifiers: [NSToolbarItemGroup.Identifier] = [
			.add,
            .sortOptions,
			.refresh,
            .openSettings
		].reversed()
        return identifiers
    }
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarDefaultItemIdentifiers(toolbar)
    }
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
				 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		var toolbarItem: NSToolbarItem?
		let item = NSToolbarItem(itemIdentifier: itemIdentifier)
		item.isBordered = true
		item.target = nil
		switch itemIdentifier {
		case .add:
			item.image = UIImage(systemName: "plus")
			item.toolTip = "Adds a new device."
			item.title = "New Device"
			item.action = NSSelectorFromString("newDevice:")
			toolbarItem = item
			
		case .refresh:
			item.image = UIImage(systemName: "arrow.clockwise.icloud")
			item.toolTip = "Get the latest data from iCloud."
			item.title = "Refresh"
			item.action = NSSelectorFromString("refreshData:")
			toolbarItem = item
			
		case .openSettings:
			item.image = UIImage(systemName: "info.circle")
			item.toolTip = "Opens the app's information page."
			item.title = "App Info"
			item.action = NSSelectorFromString("openSettings:")
			toolbarItem = item
			
		case .sortOptions:
			item.image = UIImage(systemName: "arrow.up.arrow.down")
			item.toolTip = "Change sorting options for the device list."
			item.title = "Sorting Options"
			item.action = NSSelectorFromString("openGameSaves:")
			toolbarItem = item
			
		default:
			toolbarItem = nil
		}
        item.label = item.title
//		item.title = ""
        item.autovalidates = false
        return toolbarItem
    }
    
    
}
#endif
