import UIKit

class AlbumsViewController: UIViewController {
    
    // MARK: Data
    
    let viewModel: AlbumsViewModel
    
    // MARK: - Subviews
    
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
    
    init(viewModel: AlbumsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Альбомы"
        addSubviews()
        setupConstraints()
        tuneTableView()
        bindingModelView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.updateAlbums()
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
        
        albumsTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        albumsTableView.separatorColor = .black
        
        albumsTableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    }
    
    private func addSubviews() {
        view.addSubview(albumsTableView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            albumsTableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            albumsTableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            albumsTableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            albumsTableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
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
                }
            case .error:
                break
//                DispatchQueue.main.async {
//                    self.cityTitleLabel.text = "Ошибка обновления!"
//                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension AlbumsViewController: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.albums.count
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
        
        let album = viewModel.albums[indexPath.row]
        cell.setup(with: album, and: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AlbumsViewController: UITableViewDelegate {
    
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
        print("select row \(indexPath.row)")
        print("album \(viewModel.albums[indexPath.row].name)")
        print("album ID \(viewModel.albums[indexPath.row].id)")
        
        let viewModel = AlbumViewModel(albumId: viewModel.albums[indexPath.row].id)
        let artistVC = AlbumViewController(viewModel: viewModel)
        navigationController?.pushViewController(artistVC, animated: true)
    }
}
