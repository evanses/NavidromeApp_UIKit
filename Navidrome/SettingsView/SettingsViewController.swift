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
    
    private lazy var srvView: UIView = {
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
    
    private lazy var srvVersionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Версия API"
        return label
    }()
    
    private lazy var srvVersionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = ""
        return label
    }()
    
    private lazy var secondSeparator: UIView = {
        let contentview = UIView()
        
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.backgroundColor = .myBackground
        return contentview
    }()

    private lazy var srvTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Сервер"
        return label
    }()


    private lazy var srvTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = ""
        return label
    }()
    
    private lazy var thirdSeparator: UIView = {
        let contentview = UIView()
        
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.backgroundColor = .myBackground
        return contentview
    }()

    private lazy var srvVersionMainTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Версия сервера"
        return label
    }()


    private lazy var srvVersionMainLabel: UILabel = {
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
    
    // MARK: AlertViews
    
    private lazy var confirmAlertView: UIAlertController = {
        let newAlertController = UIAlertController(title: "Вы уверены что хотите выйти?", message: nil, preferredStyle: .alert)
        
        newAlertController.addAction(UIAlertAction(
            title: "Выйти",
            style: .destructive,
            handler: { action in
                self.logout()
            })
        )
        
        newAlertController.addAction(UIAlertAction(
            title: "Отмена",
            style: .cancel,
            handler: { action in
                
            })
        )
        
        return newAlertController
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
        
        view.addSubview(srvView)
        srvView.addSubview(srvVersionTitleLabel)
        srvView.addSubview(srvVersionLabel)
        srvView.addSubview(secondSeparator)
        srvView.addSubview(srvTypeTitleLabel)
        srvView.addSubview(srvTypeLabel)
        srvView.addSubview(thirdSeparator)
        srvView.addSubview(srvVersionMainTitleLabel)
        srvView.addSubview(srvVersionMainLabel)
        
        view.addSubview(logoutView)
        logoutView.addSubview(logoutLabel)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        let leadingTrailingConstant = 8.0
        let spacerConstant = 4.0
        
        NSLayoutConstraint.activate([
            urlLoginView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 16),
            urlLoginView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leadingTrailingConstant),
            urlLoginView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -leadingTrailingConstant),
            
            hostTitleLabel.topAnchor.constraint(equalTo: urlLoginView.topAnchor, constant: leadingTrailingConstant),
            hostTitleLabel.leadingAnchor.constraint(equalTo: urlLoginView.leadingAnchor, constant: leadingTrailingConstant),
            
            hostLabel.topAnchor.constraint(equalTo: hostTitleLabel.bottomAnchor, constant: spacerConstant),
            hostLabel.leadingAnchor.constraint(equalTo: urlLoginView.leadingAnchor, constant: leadingTrailingConstant),
            
            firstSeparator.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: spacerConstant),
            firstSeparator.leadingAnchor.constraint(equalTo: urlLoginView.leadingAnchor, constant: leadingTrailingConstant),
            firstSeparator.trailingAnchor.constraint(equalTo: urlLoginView.trailingAnchor, constant: -leadingTrailingConstant),
            firstSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            
            loginTitleLabel.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: spacerConstant),
            loginTitleLabel.leadingAnchor.constraint(equalTo: urlLoginView.leadingAnchor, constant: leadingTrailingConstant),
            
            loginLabel.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: spacerConstant),
            loginLabel.leadingAnchor.constraint(equalTo: urlLoginView.leadingAnchor, constant: leadingTrailingConstant),
            
            urlLoginView.bottomAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: leadingTrailingConstant),
            
            srvView.topAnchor.constraint(equalTo: urlLoginView.bottomAnchor, constant: leadingTrailingConstant),
            srvView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leadingTrailingConstant),
            srvView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -leadingTrailingConstant),
            
            srvVersionTitleLabel.topAnchor.constraint(equalTo: srvView.topAnchor, constant: leadingTrailingConstant),
            srvVersionTitleLabel.leadingAnchor.constraint(equalTo: srvView.leadingAnchor, constant: leadingTrailingConstant),
            
            srvVersionLabel.topAnchor.constraint(equalTo: srvVersionTitleLabel.bottomAnchor, constant: spacerConstant),
            srvVersionLabel.leadingAnchor.constraint(equalTo: srvView.leadingAnchor, constant: leadingTrailingConstant),
            
            secondSeparator.topAnchor.constraint(equalTo: srvVersionLabel.bottomAnchor, constant: spacerConstant),
            secondSeparator.leadingAnchor.constraint(equalTo: srvView.leadingAnchor, constant: leadingTrailingConstant),
            secondSeparator.trailingAnchor.constraint(equalTo: srvView.trailingAnchor, constant: -leadingTrailingConstant),
            secondSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            
            srvTypeTitleLabel.topAnchor.constraint(equalTo: secondSeparator.bottomAnchor, constant: spacerConstant),
            srvTypeTitleLabel.leadingAnchor.constraint(equalTo: srvView.leadingAnchor, constant: leadingTrailingConstant),
            
            srvTypeLabel.topAnchor.constraint(equalTo: srvTypeTitleLabel.bottomAnchor, constant: spacerConstant),
            srvTypeLabel.leadingAnchor.constraint(equalTo: srvView.leadingAnchor, constant: leadingTrailingConstant),
            
            thirdSeparator.topAnchor.constraint(equalTo: srvTypeLabel.bottomAnchor, constant: spacerConstant),
            thirdSeparator.leadingAnchor.constraint(equalTo: srvView.leadingAnchor, constant: leadingTrailingConstant),
            thirdSeparator.trailingAnchor.constraint(equalTo: srvView.trailingAnchor, constant: -leadingTrailingConstant),
            thirdSeparator.heightAnchor.constraint(equalToConstant: 1.0),

            srvVersionMainTitleLabel.topAnchor.constraint(equalTo: thirdSeparator.bottomAnchor, constant: spacerConstant),
            srvVersionMainTitleLabel.leadingAnchor.constraint(equalTo: srvView.leadingAnchor, constant: leadingTrailingConstant),
            
            srvVersionMainLabel.topAnchor.constraint(equalTo: srvVersionMainTitleLabel.bottomAnchor, constant: spacerConstant),
            srvVersionMainLabel.leadingAnchor.constraint(equalTo: srvView.leadingAnchor, constant: leadingTrailingConstant),
            
            srvView.bottomAnchor.constraint(equalTo: srvVersionMainLabel.bottomAnchor, constant: leadingTrailingConstant),
            
            logoutView.topAnchor.constraint(equalTo: srvView.bottomAnchor, constant: leadingTrailingConstant),
            logoutView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: leadingTrailingConstant),
            logoutView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -leadingTrailingConstant),
            
            logoutLabel.topAnchor.constraint(equalTo: logoutView.topAnchor, constant: leadingTrailingConstant),
            logoutLabel.leadingAnchor.constraint(equalTo: logoutView.leadingAnchor, constant: leadingTrailingConstant),
            
            logoutView.bottomAnchor.constraint(equalTo: logoutLabel.bottomAnchor, constant: leadingTrailingConstant)
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
        
        srvVersionLabel.text = viewModel.version
        srvTypeLabel.text = viewModel.type
        srvVersionMainLabel.text = viewModel.serverVersion
    }
    
    // MARK: Actions
    
    @objc private func logoutTapped() {
        self.present(confirmAlertView, animated: true)
    }
    
    @objc private func logout() {
        viewModel.logout()
    }
}
