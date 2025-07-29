import UIKit
import AVFoundation

class SongCell : UITableViewCell {
    
    // MARK: Data
    
    private var song: NavidromeSong?
    
    static let reuseIdentifier = "SongCell"
    private var index: Int = 0
    
    //MARK: Subviews
    
    private let titleScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = false
        return scrollView
    }()

    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var bitrateLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        
        return label
    }()
    
    private let optionsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.image = UIImage(named:"detailsPhoto")
        return imageView
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
        contentView.addSubview(titleScrollView)
        titleScrollView.addSubview(titleLabel)

        contentView.addSubview(durationLabel)
        contentView.addSubview(bitrateLabel)
        contentView.addSubview(optionsImageView)
    }
    
    private func setupLayoutsMain() {
        NSLayoutConstraint.activate([
            titleScrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            titleScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            titleScrollView.trailingAnchor.constraint(equalTo: optionsImageView.leadingAnchor, constant: -8.0),
            titleScrollView.heightAnchor.constraint(equalToConstant: 24), 

            titleLabel.leadingAnchor.constraint(equalTo: titleScrollView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleScrollView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: titleScrollView.heightAnchor),
            
            durationLabel.topAnchor.constraint(equalTo: titleScrollView.bottomAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            
            bitrateLabel.topAnchor.constraint(equalTo: durationLabel.topAnchor),
            bitrateLabel.leadingAnchor.constraint(equalTo: durationLabel.trailingAnchor, constant: 1.0),
            
            optionsImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            optionsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            optionsImageView.heightAnchor.constraint(equalToConstant: 25),
            optionsImageView.widthAnchor.constraint(equalToConstant: 25),
            
            contentView.bottomAnchor.constraint(equalTo: bitrateLabel.bottomAnchor, constant: 4.0)
        ])
    }
    
    private func animateTitleLabelIfNeeded() {
        layoutIfNeeded() // убедись, что размеры заданы

        let labelWidth = titleLabel.intrinsicContentSize.width
        let scrollViewWidth = titleScrollView.bounds.width

        guard labelWidth > scrollViewWidth else {
            titleScrollView.setContentOffset(.zero, animated: false)
            return
        }

        let offset = CGPoint(x: labelWidth - scrollViewWidth, y: 0)

        UIView.animate(withDuration: 15.0,
                       delay: 1.0,
                       options: [.curveLinear, .repeat, .autoreverse],
                       animations: {
            self.titleScrollView.setContentOffset(offset, animated: false)
        }, completion: nil)
    }

    
    // MARK: - Public
    
    func setup(with song: NavidromeSong, and index: Int) {
        titleLabel.text = song.title
        let munutes: Int = song.duration / 60
        let seconds: Int = song.duration % 60
        durationLabel.text = "\(munutes)мин \(seconds)с"
        bitrateLabel.text = "• \(song.bitRate) kbps"
        self.song = song
        self.index = index
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animateTitleLabelIfNeeded()
        }
    }
}

