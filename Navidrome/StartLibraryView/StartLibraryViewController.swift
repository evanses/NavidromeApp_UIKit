import UIKit

class StartLibraryViewController: UIViewController {
    
    // MARK: - Data
    
    private let buttonData = [
        ("Исполнители", "music.microphone"),
        ("Альбомы", "music.note.list"),
        ("Плейлисты", "list.bullet"),
        ("Жанры", "guitars"),
        ("Избранное", "star.fill"),
        ("Все треки", "music.note"),
        ("Скачанное", "icloud.and.arrow.down"),
    ]
    
    // MARK: - Subviews
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(StartLibraryButtonCell.self, forCellWithReuseIdentifier: StartLibraryButtonCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubviews()
        setupConstraints()
        
        navigationItem.title = "Библиотека"
    }
    
    // MARK: - Setup Methods
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension StartLibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StartLibraryButtonCell.reuseIdentifier, for: indexPath) as! StartLibraryButtonCell
        let (title, iconName) = buttonData[indexPath.item]
        cell.configure(withTitle: title, iconName: iconName)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StartLibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 12 // Interitem spacing
        let insets = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let totalPadding = insets.sectionInset.left + insets.sectionInset.right + padding
        let width = (collectionView.bounds.width - totalPadding) / 2 // Two columns
        return CGSize(width: width, height: width) // Square cells
    }
}

// MARK: - UICollectionViewDelegate
extension StartLibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        guard index >= 0 && index < buttonData.count else {
            print("Unknown cell tapped")
            return
        }
        
        let title = buttonData[index].0
        switch title {
        case "Избранное":
            print("Tapped Избранное: Show favorite tracks")
            // Add logic to show favorite tracks
        case "Все треки":
            print("Tapped Все треки: Show all tracks")
            // Add logic to show all tracks
        case "Исполнители":
            print("Tapped Исполнители: Show artists")
            
            let artistsViewModel = ArtistsViewModel()
            let articstsVC = ArtistsViewController(viewModel: artistsViewModel)
            navigationController?.pushViewController(articstsVC, animated: true)
        case "Альбомы":
            print("Tapped Альбомы: Show albums")
            
            let albumViewModel = AlbumsViewModel()
            let albumsVC = AlbumsViewController(viewModel: albumViewModel)
            navigationController?.pushViewController(albumsVC, animated: true)
        case "Плейлисты":
            print("Tapped Плейлисты: Show playlists")
            // Add logic to show playlists
        case "Жанры":
            print("Tapped Жанры: Show genres")
            // Add logic to show genres
        default:
            print("Unknown cell tapped")
        }
    }
}
