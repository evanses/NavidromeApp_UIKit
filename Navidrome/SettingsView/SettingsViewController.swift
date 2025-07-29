import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: Data
    
    var viewModel: SettingsViewModel
    
    // MARK: Subviews
    
    private lazy var urlLoginView: UIView = {
        let contentview = UIView()
        
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.backgroundColor = .white
        contentview.layer.cornerRadius = 10
        contentview.clipsToBounds = false
        
        contentview.layer.shadowColor = UIColor.black.cgColor
        contentview.layer.shadowOpacity = 0.1
        contentview.layer.shadowOffset = CGSize(width: 0, height: -2)
        contentview.layer.shadowRadius = 4

        return contentview
    }()
    
    private lazy var hostTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Адрес сервера"
        return label
    }()
    
    private lazy var hostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = ""
        return label
    }()
    
    private lazy var firstSeparator: UIView = {
        let contentview = UIView()
        
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.backgroundColor = .myBackground
        return contentview
    }()

    private lazy var loginTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Логин"
        return label
    }()


    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = ""
        return label
    }()
    
    private lazy var logoutView: UIView = {
        let contentview = UIView()
        
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.backgroundColor = .white
        contentview.layer.cornerRadius = 10
        contentview.clipsToBounds = false
        
        contentview.layer.shadowColor = UIColor.black.cgColor
        contentview.layer.shadowOpacity = 0.1
        contentview.layer.shadowOffset = CGSize(width: 0, height: -2)
        contentview.layer.shadowRadius = 4
        
        return contentview
    }()

    private lazy var logoutLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Выйти"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .myBackground
        
        addSubviews()
        setupConstraints()
        setupActions()
        setupView()
    }
    
    // MARK: - Setup Methods
    
    private func addSubviews() {
        view.addSubview(urlLoginView)
        urlLoginView.addSubview(hostTitleLabel)
        urlLoginView.addSubview(hostLabel)
        urlLoginView.addSubview(firstSeparator)
        urlLoginView.addSubview(loginTitleLabel)
        urlLoginView.addSubview(loginLabel)
        
        view.addSubview(logoutView)
        logoutView.addSubview(logoutLabel)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        let leadingTrailingConstant = 8.0
        
        NSLayoutConstraint.activate([
            urlLoginView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 16),
            urlLoginView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leadingTrailingConstant),
            urlLoginView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -leadingTrailingConstant),
            
            hostTitleLabel.topAnchor.constraint(equalTo: urlLoginView.topAnchor, constant: 8.0),
            hostTitleLabel.leadingAnchor.constraint(equalTo: urlLoginView.leadingAnchor, constant: 8.0),
            
            hostLabel.topAnchor.constraint(equalTo: hostTitleLabel.bottomAnchor, constant: 4.0),
            hostLabel.leadingAnchor.constraint(equalTo: urlLoginView.leadingAnchor, constant: 8.0),
            
            firstSeparator.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 4.0),
            firstSeparator.leadingAnchor.constraint(equalTo: urlLoginView.leadingAnchor, constant: 8.0),
            firstSeparator.trailingAnchor.constraint(equalTo: urlLoginView.trailingAnchor, constant: -8.0),
            firstSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            
            loginTitleLabel.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 4.0),
            loginTitleLabel.leadingAnchor.constraint(equalTo: urlLoginView.leadingAnchor, constant: 8.0),
            
            loginLabel.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 4.0),
            loginLabel.leadingAnchor.constraint(equalTo: urlLoginView.leadingAnchor, constant: 8.0),
            
            urlLoginView.bottomAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8.0),
            
            logoutView.topAnchor.constraint(equalTo: urlLoginView.bottomAnchor, constant: 8.0),
            logoutView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leadingTrailingConstant),
            logoutView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -leadingTrailingConstant),
            
            logoutLabel.topAnchor.constraint(equalTo: logoutView.topAnchor, constant: 8.0),
            logoutLabel.leadingAnchor.constraint(equalTo: logoutView.leadingAnchor, constant: 8.0),
            
            logoutView.bottomAnchor.constraint(equalTo: logoutLabel.bottomAnchor, constant: 8.0)
        ])
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutTapped))
        logoutLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Public
    
    private func setupView() {
        hostLabel.text = viewModel.host
        loginLabel.text = viewModel.login
    }
    
    // MARK: Actions
    
    @objc private func logoutTapped() {
        viewModel.logout()
    }
}
