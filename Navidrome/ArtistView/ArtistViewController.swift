import UIKit

class ArtistViewController: UIViewController {
    
    // MARK: Data
    
    let viewModel: ArtistViewModel
    
    // MARK: Subviews
    
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var albumsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Альбомы"
        return label
    }()
    
    private lazy var albumsTableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        return tableView
    }()

    
    // MARK: - Lifecycle
    
    init(viewModel: ArtistViewModel) {
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
        
        viewModel.updateArtistInfo()
    }
    
    // MARK: - Setup Methods
    
    private func tuneTableView() {
        albumsTableView.estimatedRowHeight = 70.0
        albumsTableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            albumsTableView.sectionHeaderTopPadding = 0.0
        }
         
        albumsTableView.tableHeaderView = UIView(frame: .zero)
        albumsTableView.tableFooterView = UIView(frame: .zero)
        
        albumsTableView.register(
            AlbumsCell.self,
            forCellReuseIdentifier: AlbumsCell.reuseIdentifier
        )
        
        albumsTableView.dataSource = self
        albumsTableView.delegate = self
        
        albumsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        albumsTableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    }
    
    private func addSubviews() {
        view.addSubview(artistImageView)
        view.addSubview(titleLabel)
        view.addSubview(albumsLabel)
        view.addSubview(albumsTableView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            artistImageView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 8.0),
            artistImageView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            artistImageView.widthAnchor.constraint(equalToConstant: 200),
            artistImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: 8.0),
            titleLabel.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            
            albumsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            albumsLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16.0),
            
            albumsTableView.topAnchor.constraint(equalTo: albumsLabel.bottomAnchor, constant: 4.0),
            albumsTableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 8.0),
            albumsTableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -8.0),
            albumsTableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -8.0)
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
                    self.albumsTableView.reloadData()
                    self.setupView()
                }
            case .error:
                break
//                DispatchQueue.main.async {
//                    self.cityTitleLabel.text = "Ошибка обновления!"
//                }
            }
        }
    }
    
    // MARK: Public
    
    func setupView() {
        if let artist = viewModel.artist {
            NavidromeApiManager.shared.fetchImage(url: artist.artistImageUrl){ resut in
                switch resut {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.artistImageView.image = image
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.artistImageView.image = UIImage(systemName: "music.microphone")
                    }
                }
            }
            
            titleLabel.text = artist.name
        }
    }
}

// MARK: - UITableViewDataSource

extension ArtistViewController: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if let artist = viewModel.artist {
            return artist.album.count
        } else {
            return 0
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = albumsTableView.dequeueReusableCell(
            withIdentifier: AlbumsCell.reuseIdentifier,
            for: indexPath
        ) as? AlbumsCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        if let artist = viewModel.artist {
            let album = artist.album[indexPath.row]
            cell.setup(with: album, and: indexPath.row)
            return cell
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ArtistViewController: UITableViewDelegate {
    
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
        if let artist = viewModel.artist {
            print("select row \(indexPath.row)")
            print("album \(artist.album[indexPath.row].name)")
            print("album ID \(artist.album[indexPath.row].id)")
    
            let viewModel = AlbumViewModel(albumId: artist.album[indexPath.row].id)
            let artistVC = AlbumViewController(viewModel: viewModel)
            navigationController?.pushViewController(artistVC, animated: true)
        }
    }
}
