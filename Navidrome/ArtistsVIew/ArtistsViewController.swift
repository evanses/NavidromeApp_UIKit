import UIKit

class ArtistsViewController: UIViewController {
    
    // MARK: Data
    
    let viewModel: ArtistsViewModel
    
    // MARK: Subviews
    
    private lazy var artistsTableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: ArtistsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Исполнители"
        addSubviews()
        setupConstraints()
        tuneTableView()
        bindingModelView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.updateArtists()
    }
    
    // MARK: - Setup Methods
    
    private func tuneTableView() {
        artistsTableView.estimatedRowHeight = 70.0
        artistsTableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            artistsTableView.sectionHeaderTopPadding = 0.0
        }
         
        artistsTableView.tableHeaderView = UIView(frame: .zero)
        artistsTableView.tableFooterView = UIView(frame: .zero)
        
        artistsTableView.register(
            ArtistsCell.self,
            forCellReuseIdentifier: ArtistsCell.reuseIdentifier
        )
        
        artistsTableView.dataSource = self
        artistsTableView.delegate = self
        
        artistsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        artistsTableView.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    }
    
    private func addSubviews() {
        view.addSubview(artistsTableView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            artistsTableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            artistsTableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            artistsTableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            artistsTableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
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
                    self.artistsTableView.reloadData()
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

extension ArtistsViewController: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.artists.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = artistsTableView.dequeueReusableCell(
            withIdentifier: ArtistsCell.reuseIdentifier,
            for: indexPath
        ) as? ArtistsCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        let artist = viewModel.artists[indexPath.row]
        cell.setup(with: artist, and: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ArtistsViewController: UITableViewDelegate {
    
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
        print("Artist \(viewModel.artists[indexPath.row].name)")
        print("Artist ID \(viewModel.artists[indexPath.row].id)")
        
        let viewModel = ArtistViewModel(artistId: viewModel.artists[indexPath.row].id)
        let artistVC = ArtistViewController(viewModel: viewModel)
        navigationController?.pushViewController(artistVC, animated: true)
    }
}
