import UIKit

class MiniPlayerView: UIView {
    
    var isPlayerHidden = true
    
    private lazy var inView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let songImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.image = UIImage(systemName: "music.note")
        return imageView
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = ""
        label.numberOfLines = 1
        return label
    }()

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
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Трек не выбран"
        label.numberOfLines = 1
        return label
    }()
    
    private let playPauseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "play")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupActions()
    }

    private func setupView() {
        backgroundColor = UIColor.systemGray6
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 4
        
        isHidden = isPlayerHidden
        
        addSubview(inView)
        addSubview(playPauseImageView)
        addSubview(songImageView)
        addSubview(titleScrollView)
        inView.addSubview(artistLabel)
        inView.addSubview(titleScrollView)
        titleScrollView.addSubview(titleLabel)
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            playPauseImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            playPauseImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            playPauseImageView.widthAnchor.constraint(equalToConstant: 35),
            playPauseImageView.heightAnchor.constraint(equalToConstant: 35),
            
            songImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            songImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            songImageView.widthAnchor.constraint(equalToConstant: 50),
            songImageView.heightAnchor.constraint(equalToConstant: 50),
            
            inView.centerYAnchor.constraint(equalTo: songImageView.centerYAnchor),
            inView.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 4.0),
            inView.trailingAnchor.constraint(equalTo: playPauseImageView.leadingAnchor, constant: -4.0),
            inView.bottomAnchor.constraint(equalTo: titleScrollView.bottomAnchor),
                        
            artistLabel.topAnchor.constraint(equalTo: inView.topAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: inView.leadingAnchor),
            
            titleScrollView.topAnchor.constraint(equalTo: artistLabel.bottomAnchor),
            titleScrollView.leadingAnchor.constraint(equalTo: inView.leadingAnchor),
            titleScrollView.trailingAnchor.constraint(equalTo: inView.trailingAnchor),
            titleScrollView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: titleScrollView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleScrollView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: titleScrollView.heightAnchor),
        ])
    }

    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playPauseTapped))
        playPauseImageView.addGestureRecognizer(tapGesture)
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

    // MARK: Actions

    @objc private func playPauseTapped() {
        PlayerManager.shared.playPauseTapped()
    }
}

extension MiniPlayerView: MiniPlayerViewDelegate {
    func updateView(song: NavidromeSong) {
        if isPlayerHidden {
            isPlayerHidden = false
            self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            self.isHidden = isPlayerHidden

            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseOut,
                           animations: {
                self.transform = .identity
            }, completion: nil)
        }

        NavidromeApiManager.shared.fetchImage(coverArt: song.coverArt){ resut in
            switch resut {
            case .success(let image):
                DispatchQueue.main.async {
                    self.songImageView.image = image
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.songImageView.image = UIImage(systemName: "music.note")
                }
            }
        }
        
        titleLabel.text = song.title
        artistLabel.text = song.artist
        
        playPauseImageView.image = PlayerManager.shared.isPlaying ? UIImage(systemName: "pause") : UIImage(systemName: "play")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animateTitleLabelIfNeeded()
        }
    }
}
