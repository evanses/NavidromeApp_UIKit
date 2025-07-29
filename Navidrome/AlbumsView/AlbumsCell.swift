import UIKit


class AlbumsCell : UITableViewCell {
    
    // MARK: Data
    
    static let reuseIdentifier = "AlbumsCell"
    private var index: Int = 0
    
    //MARK: Subviews
    
    private let albumImageView: UIImageView = {
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
        
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var songCountLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var inView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .default,
            reuseIdentifier: reuseIdentifier
        )
        
        setupView()
        setupSubviews()
        
        setupLayoutsMain()
    }
    
    // MARK: Private
    
    private func setupView() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
    }
    
    private func setupSubviews() {
        contentView.addSubview(albumImageView)
        contentView.addSubview(inView)
        inView.addSubview(titleLabel)
        inView.addSubview(songCountLabel)
    }
    
    private func setupLayoutsMain() {
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            albumImageView.widthAnchor.constraint(equalToConstant: 70),
            albumImageView.heightAnchor.constraint(equalToConstant: 70),
            
            inView.centerYAnchor.constraint(equalTo: albumImageView.centerYAnchor),
            inView.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 8.0),
            inView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8.0),
            inView.bottomAnchor.constraint(equalTo: songCountLabel.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: inView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: inView.leadingAnchor),
            
            songCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1.0),
            songCountLabel.leadingAnchor.constraint(equalTo: inView.leadingAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 4.0)
        ])
    }
    
    // MARK: - Public
    
    func setup(with album: NavidroveAlbum, and index: Int) {
        titleLabel.text = album.name
        songCountLabel.text = "Треков: \(album.songCount)"
        NavidromeApiManager.shared.fetchImage(coverArt: album.coverArt){ resut in
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
        
        self.index = index
    }
}

