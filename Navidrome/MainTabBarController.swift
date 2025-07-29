import UIKit

protocol MiniPlayerViewDelegate {
    func updateView(song: NavidromeSong)
}

class MainTabBarController: UITabBarController {
    let miniPlayerView = MiniPlayerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiniPlayer()
    }

    private func setupMiniPlayer() {
        miniPlayerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(miniPlayerView)

        NSLayoutConstraint.activate([
            miniPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            miniPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            miniPlayerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            miniPlayerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
