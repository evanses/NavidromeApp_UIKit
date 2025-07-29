import UIKit
import AVFoundation

class AlbumViewController: UIViewController {
    
    // MARK: Data
    
    let viewModel: AlbumViewModel
    var player: AVPlayer?

    var isPlaying: Bool = false
    var playingSongId: Int = -1
    
    // MARK: Subviews
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private lazy var albumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var songsTableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews()
        setupConstraints()
        tuneTableView()
        bindingModelView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.updateAlbumInfo()
    }
    
    // MARK: - Setup Methods
    
    private func tuneTableView() {
        songsTableView.estimatedRowHeight = 70.0
        songsTableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            songsTableView.sectionHeaderTopPadding = 0.0
        }
         
        songsTableView.tableHeaderView = UIView(frame: .zero)
        songsTableView.tableFooterView = UIView(frame: .zero)
        
        songsTableView.register(
            SongCell.self,
            forCellReuseIdentifier: SongCell.reuseIdentifier
        )
        
        songsTableView.dataSource = self
        songsTableView.delegate = self
        
        songsTableView.separatorStyle = .singleLine
        songsTableView.separatorColor = .black
        
        songsTableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        headerView.addSubview(albumImageView)
        headerView.addSubview(albumLabel)
        view.addSubview(songsTableView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 2.0),
            
            albumImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 2.0),
            albumImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8.0),
            albumImageView.widthAnchor.constraint(equalToConstant: 40),
            albumImageView.heightAnchor.constraint(equalToConstant: 40),

            albumLabel.centerYAnchor.constraint(equalTo: albumImageView.centerYAnchor),
            albumLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 4.0),
            
            songsTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 4),
            songsTableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            songsTableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            songsTableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
    
    private func bindingModelView() {
        viewModel.stateChanger = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .initing:
                break
            case .loaded:
                DispatchQueue.main.async {
                    self.setupView()
                }
            case .error:
                break
            }
        }
    }
    
    // MARK: Public
    
    func setupView() {
        songsTableView.reloadData()
        if let albumFull = viewModel.albumFull {
            NavidromeApiManager.shared.fetchImage(coverArt: albumFull.coverArt){ resut in
                switch resut {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.albumImageView.image = image
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.albumImageView.image = UIImage(systemName: "music.microphone")
                    }
                }
            }
            
            NavidromeApiManager.shared.fetchArtistFull(for: albumFull.artistId) { result in
                switch result {
                case .success(let artist):
                    DispatchQueue.main.async {
                        self.navigationItem.title = artist.name
                    }
                case .failure(_):
                    print("Error while fetchArtistFull in view album")
                }
            }
            
            albumLabel.text = albumFull.name
        }
    }
    
    func playSong(with id: Int) {
        guard let song = viewModel.albumFull?.song[id] else {
            return
        }
        
        guard let apiHost = KeychainManager.shared.getHost(),
            let login = KeychainManager.shared.getLogin(),
            let pass = KeychainManager.shared.getPassword() else {
                return
            }
        
        guard let url = URL(string: "\(apiHost)/rest/stream.view?u=\(login)&p=\(pass)&v=1.15&c=iosApp&id=\(song.id)") else {
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPlaying = true
        playingSongId = id
        
        print("Play song with ID: \(song.id)")
    }
}

// MARK: - UITableViewDataSource

extension AlbumViewController: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.albumFull?.song.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = songsTableView.dequeueReusableCell(
            withIdentifier: SongCell.reuseIdentifier,
            for: indexPath
        ) as? SongCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        let song = viewModel.albumFull?.song[indexPath.row]
        cell.setup(with: song!, and: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AlbumViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let song = viewModel.albumFull?.song[indexPath.row] else {
            return
        }

        PlayerManager.shared.play(song: song)
    }
}
