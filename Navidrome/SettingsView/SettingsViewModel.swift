import Foundation

final class SettingsViewModel {
    var host: String = ""
    var login: String = ""
    
    var version: String = ""
    var type: String = ""
    var serverVersion: String = ""
    
    init() {
        guard let apiHost = KeychainManager.shared.getHost(),
            let login = KeychainManager.shared.getLogin(),
            let pass = KeychainManager.shared.getPassword() else {
                return
            }
        self.host = apiHost
        self.login = login
        
        NavidromeApiManager.shared.loginCheck(
            host: apiHost,
            login: login,
            password: pass) { result in
                switch result {
                case .success(let res):
                    DispatchQueue.main.async {
                        self.version = res.version
                        self.type = res.type
                        self.serverVersion = res.serverVersion
                    }
                case .failure(let error):
                    print("error while loginCheck in SettingViewModel")
                }
            }

    }
    
    func logout() {
        KeychainManager.shared.deleteCredentials()
        AppRouter.shared.showLogin()
    }
}
