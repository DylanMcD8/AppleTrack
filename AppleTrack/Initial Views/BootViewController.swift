//
//  BootViewController.swift
//  AppleTrack
//
//  Created by Dylan McDonald on 7/22/22.
//

import UIKit
import AVFoundation

var audioPlayer: AVAudioPlayer?

class BootViewController: UIViewController {

	@IBOutlet weak var backgroundColorView: UIView!
	@IBOutlet weak var iconView: UIImageView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.iconView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
		self.iconView.alpha = 0
		self.backgroundColorView.alpha = 0
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		DispatchQueue.main.async {
			#if targetEnvironment(macCatalyst)
			updateTitlebarTitle(with: "Welcome", session: (self.view.window?.windowScene?.session)!)
			updateTitlebarSubtitle(with: "", session: (self.view.window?.windowScene?.session)!)
//			hideTitlebar(session: (self.view.window?.windowScene?.session)!)
			#endif
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		self.iconView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
		self.iconView.alpha = 0
		self.backgroundColorView.alpha = 0
	}
    
	override func viewDidAppear(_ animated: Bool) {
		needsBoot = false
		let session = AVAudioSession.sharedInstance()
		try? session.setCategory(.ambient, mode: .default)
		try? session.setActive(true)
		guard let path = Bundle.main.path(forResource: "custombootchime", ofType: "wav") else { return }
		let url = URL(fileURLWithPath: path)
		audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
		audioPlayer?.prepareToPlay()
		audioPlayer?.play()
		
		UIView.animate(withDuration: 0.5) {
			self.iconView.transform = CGAffineTransform(scaleX: 1, y: 1)
			self.iconView.alpha = 1
			self.backgroundColorView.alpha = 1
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [self] in
			UIView.animate(withDuration: 0.5) {
				self.iconView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
				self.iconView.alpha = 0
			}
//			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main Screen Nav")
//			vc.modalPresentationStyle = .fullScreen
//			vc.modalTransitionStyle = .crossDissolve
//			present(vc, animated: true)
			self.dismiss(animated: true)
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		UIView.animate(withDuration: 0.3) {
			self.iconView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
			self.iconView.alpha = 0
		}
//		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main Screen Nav")
//		vc.modalPresentationStyle = .fullScreen
//		vc.modalTransitionStyle = .crossDissolve
//		present(vc, animated: true)
		self.dismiss(animated: true)
		audioPlayer?.stop()
	}

}
