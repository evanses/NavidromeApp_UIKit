import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Data
    
    var viewModel: LoginViewModel
    
    // MARK: - Subviews
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Подключение сервера"
        return label
    }()
    
    private lazy var urlLoginPasswordView: UIView = {
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
    
    private lazy var hostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Адрес сервера"
        return label
    }()

    private lazy var hostTextField: UITextField = {
        let textInput = UITextField()
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.font = UIFont.systemFont(ofSize: 16)
        textInput.textColor = .black
        textInput.returnKeyType = UIReturnKeyType.done
        textInput.attributedPlaceholder = NSAttributedString(
            string: "https://example.ru",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textInput.autocapitalizationType = .none
//        textInput.delegate = self
        
        textInput.backgroundColor = .clear
        
        return textInput
    }()
    
    private lazy var firstSeparator: UIView = {
        let contentview = UIView()
        
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.backgroundColor = .myBackground
        return contentview
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Логин"
        return label
    }()
    
    private lazy var loginTextField: UITextField = {
        let textInput = UITextField()
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.font = UIFont.systemFont(ofSize: 16)
        textInput.textColor = .black
        textInput.returnKeyType = UIReturnKeyType.done
        textInput.attributedPlaceholder = NSAttributedString(
            string: "user",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textInput.autocapitalizationType = .none
//        textInput.delegate = self
        
        textInput.backgroundColor = .clear
        
        return textInput
    }()
    
    private lazy var secondSeparator: UIView = {
        let contentview = UIView()
        
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.backgroundColor = .myBackground
        return contentview
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Пароль"
        return label
    }()
    
    private lazy var passowordTextField: UITextField = {
        let textInput = UITextField()
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.font = UIFont.systemFont(ofSize: 16)
        textInput.textColor = .black
        textInput.isSecureTextEntry = true
        textInput.returnKeyType = UIReturnKeyType.done
        textInput.attributedPlaceholder = NSAttributedString(
            string: "P@ssw0rd",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textInput.autocapitalizationType = .none
//        textInput.delegate = self
        
        textInput.backgroundColor = .clear
        
        return textInput
    }()
    
    private lazy var submitView: UIView = {
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

    private lazy var submitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .accent
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Войти"
        label.isUserInteractionEnabled = true
        return label
    }()

    // MARK: - Lifecycle
    
    init(viewModel: LoginViewModel) {
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
        bindingModelView()
    }
    
    // MARK: - Setup Methods
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        
        view.addSubview(urlLoginPasswordView)
        
        urlLoginPasswordView.addSubview(hostLabel)
        urlLoginPasswordView.addSubview(hostTextField)
        
        urlLoginPasswordView.addSubview(firstSeparator)
        
        urlLoginPasswordView.addSubview(loginLabel)
        urlLoginPasswordView.addSubview(loginTextField)
        
        urlLoginPasswordView.addSubview(secondSeparator)
        
        urlLoginPasswordView.addSubview(passwordLabel)
        urlLoginPasswordView.addSubview(passowordTextField)
        
        view.addSubview(submitView)
        submitView.addSubview(submitLabel)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        let leadingTrailingConstant = 8.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 8.0),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 24.0),
            
            
            urlLoginPasswordView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            urlLoginPasswordView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16.0),
            urlLoginPasswordView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16.0),
            
            hostLabel.topAnchor.constraint(equalTo: urlLoginPasswordView.topAnchor, constant: 8.0),
            hostLabel.leadingAnchor.constraint(equalTo: urlLoginPasswordView.leadingAnchor, constant: leadingTrailingConstant),
            
            hostTextField.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 4.0),
            hostTextField.leadingAnchor.constraint(equalTo: urlLoginPasswordView.leadingAnchor, constant: leadingTrailingConstant),
            
            firstSeparator.topAnchor.constraint(equalTo: hostTextField.bottomAnchor, constant: 4.0),
            firstSeparator.leadingAnchor.constraint(equalTo: urlLoginPasswordView.leadingAnchor, constant: leadingTrailingConstant),
            firstSeparator.trailingAnchor.constraint(equalTo: urlLoginPasswordView.trailingAnchor, constant: -leadingTrailingConstant),
            firstSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            
            loginLabel.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 4.0),
            loginLabel.leadingAnchor.constraint(equalTo: urlLoginPasswordView.leadingAnchor, constant: leadingTrailingConstant),
            
            loginTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 4.0),
            loginTextField.leadingAnchor.constraint(equalTo: urlLoginPasswordView.leadingAnchor, constant: leadingTrailingConstant),
            
            secondSeparator.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 4.0),
            secondSeparator.leadingAnchor.constraint(equalTo: urlLoginPasswordView.leadingAnchor, constant: leadingTrailingConstant),
            secondSeparator.trailingAnchor.constraint(equalTo: urlLoginPasswordView.trailingAnchor, constant: -leadingTrailingConstant),
            secondSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            
            passwordLabel.topAnchor.constraint(equalTo: secondSeparator.bottomAnchor, constant: 4.0),
            passwordLabel.leadingAnchor.constraint(equalTo: urlLoginPasswordView.leadingAnchor, constant: leadingTrailingConstant),
            
            passowordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 4.0),
            passowordTextField.leadingAnchor.constraint(equalTo: urlLoginPasswordView.leadingAnchor, constant: leadingTrailingConstant),
            
            urlLoginPasswordView.bottomAnchor.constraint(equalTo: passowordTextField.bottomAnchor, constant: 8.0),
            
            submitView.topAnchor.constraint(equalTo: urlLoginPasswordView.bottomAnchor, constant: 8.0),
            submitView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16.0),
            submitView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16.0),
            
            submitLabel.topAnchor.constraint(equalTo: submitView.topAnchor, constant: 8.0),
            submitLabel.leadingAnchor.constraint(equalTo: submitView.leadingAnchor, constant: leadingTrailingConstant),

            submitView.bottomAnchor.constraint(equalTo: submitLabel.bottomAnchor, constant: 8.0)
        ])
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(submitTapped))
        submitLabel.addGestureRecognizer(tapGesture)
    }
    
    private func bindingModelView() {
        viewModel.stateChanger = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .initing:
                break
            case .loginSuccess:
                DispatchQueue.main.async {
                    self.titleLabel.text = "Успешное подключение"
                    self.titleLabel.textColor = .green
                }
            case .loginFailed:
                DispatchQueue.main.async {
                    self.titleLabel.text = self.viewModel.errorMessage
                    self.titleLabel.textColor = .red
                }
            case .inProccess:
                break
            }
        }
    }
    
    // MARK: Actions

    @objc private func submitTapped() {
        guard let host = hostTextField.text,
        let login = loginTextField.text,
                let password = passowordTextField.text
        else { return }
        
        titleLabel.text = "Подключение..."
        titleLabel.textColor = .accent
        
        viewModel.check(
            host: host,
            login: login,
            password: password
        )
    }
}
