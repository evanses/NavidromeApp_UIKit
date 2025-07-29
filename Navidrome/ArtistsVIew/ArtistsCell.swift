import UIKit


class ArtistsCell : UITableViewCell {
    
    // MARK: Data
    
    static let reuseIdentifier = "ArtistsCell"
    private var index: Int = 0
    
    //MARK: Subviews
    
    private let articsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    
    /// название активности
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        
        return label
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
        contentView.addSubview(articsImageView)
        contentView.addSubview(titleLabel)
    }
    
    private func setupLayoutsMain() {
        NSLayoutConstraint.activate([
            articsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            articsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            articsImageView.widthAnchor.constraint(equalToConstant: 70),
            articsImageView.heightAnchor.constraint(equalToConstant: 70),
            
            titleLabel.centerYAnchor.constraint(equalTo: articsImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: articsImageView.trailingAnchor, constant: 8.0),
            
            contentView.bottomAnchor.constraint(equalTo: articsImageView.bottomAnchor, constant: 4.0)
        ])
    }
    
    // MARK: - Public
    
    func setup(with artist: NavidromeArtist, and index: Int) {
        titleLabel.text = artist.name

        NavidromeApiManager.shared.fetchImage(url: artist.artistImageUrl) { resut in
            switch resut {
            case .success(let image):
                DispatchQueue.main.async {
                    self.articsImageView.image = image
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.articsImageView.image = UIImage(systemName: "music.microphone")
                }
            }
            
        }
        
        self.index = index
    }
}
