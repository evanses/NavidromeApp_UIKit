import Foundation

final class LoginViewModel {
    
    var errorMessage = ""
    
    enum State {
        case initing
        case inProccess
        case loginSuccess
        case loginFailed
    }
    var stateChanger: ((State) -> Void)?
    private var state: State = .initing {
        didSet {
            stateChanger?(state)
        }
    }

    func check(host: String, login: String, password: String) {
        NavidromeApiManager.shared.loginCheck(
            host: host,
            login: login,
            password: password) { result in
                switch result {
                case .success(_):
                    self.state = .loginSuccess
                    self.saveCreds(
                        host: host,
                        login: login,
                        password: password
                    )
                    DispatchQueue.main.async {
                        AppRouter.shared.showMainInterface()
                    }
                case .failure(let error):
                    self.state = .loginFailed
                    self.errorMessage = error.description
                }
            }
    }
    
    func saveCreds(host: String, login: String, password: String) {
        KeychainManager.shared.saveData(host: host, login: login, password: password)
    }
}
