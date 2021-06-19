//
//  HomeController.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/25.
//

import UIKit
import AVKit

class HomeController: UIViewController {
    let viewModel = PlayerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchVideo(6230)
        self.title = "Bepro_iOS_Task"
        view.addSubview(viewModel.player.displayView)
        self.viewModel.player.displayView.closeButton.isHidden = true
        self.viewModel.player.play()
        self.viewModel.player.backgroundMode = .suspend
        self.viewModel.player.delegate = self
        self.viewModel.player.displayView.delegate = self
        self.viewModel.player.displayView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(self.view.snp.width).multipliedBy(9.0/16.0)
        }
        view.addSubview(self.viewModel.playerView.tableView)
        self.viewModel.playerView.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.viewModel.player.displayView.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        viewModel.player.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .default
        viewModel.player.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow})?.windowScene?.interfaceOrientation
            switch interfaceOrientation {
            case .landscapeLeft, .landscapeRight:
                self.viewModel.player.displayView.closeButton.isHidden = false
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.viewModel.player.displayView.snp.remakeConstraints({ (make) in
                    make.width.equalTo(self.view.bounds.width)
                    make.height.equalTo(self.view.bounds.height)
                })
            case .portrait:
                self.viewModel.player.displayView.closeButton.isHidden = true
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.viewModel.player.displayView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                    make.left.equalTo(self.view.snp.left)
                    make.right.equalTo(self.view.snp.right)
                    make.height.equalTo(self.view.snp.width).multipliedBy(9.0/16.0)
                }
                self.view.addSubview(self.viewModel.playerView.tableView)
                self.viewModel.playerView.tableView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.viewModel.player.displayView.snp.bottom)
                    make.left.equalTo(self.view.snp.left)
                    make.right.equalTo(self.view.snp.right)
                    make.bottom.equalTo(self.view.snp.bottom)
                }
            default:
                print("default")
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            if let orientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow})?.windowScene?.interfaceOrientation {
                print(orientation.rawValue)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension HomeController: PlayerDelegate {
    func player(_ player: Player, playerFailed error: PlayerError) {
        print(error)
    }
    func player(_ player: Player, stateDidChange state: PlayerState) {
        print("Player State --- ",state)
    }
    func player(_ player: Player, bufferStateDidChange state: PlayerBufferState) {
        print("Player Buffer State --- ", state)
    }
}
extension HomeController: PlayerViewDelegate {
    func playerView(_ playerView: PlayerView, willFullscreen isFullscreen: Bool) {
        print("Full Screen ---", isFullscreen)
    }
    func playerView(didTappedClose playerView: PlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        }
    }
    func playerView(didDisplayControl playerView: PlayerView) {
//        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
        self.prefersStatusBarHidden
    }
}


