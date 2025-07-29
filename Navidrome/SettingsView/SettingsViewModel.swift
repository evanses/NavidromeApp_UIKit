final class SettingsViewModel {
    var host: String = ""
    var login: String = ""
    
    init() {
        guard let apiHost = KeychainManager.shared.getHost(),
            let login = KeychainManager.shared.getLogin(),
            let pass = KeychainManager.shared.getPassword() else {
                return
            }
        self.host = apiHost
        self.login = login
    }
    
    func logout() {
        KeychainManager.shared.deleteCredentials()
        AppRouter.shared.showLogin()
    }
}
