import UIKit
import KeychainAccess

class KeychainManager: ObservableObject {
    static let shared = KeychainManager()
    
    private let keychain = Keychain(service: "ru.hiix.app.Navidrome")
    
    var host: String = ""
    var login: String = ""
    var password: String = ""

    private let hostKey = "host"
    private let loginKey = "login"
    private let passwordKey = "password"
    
    // MARK: INIT
    init() {}
    
    func isAuthorized() -> Bool {
        getHost() != nil
    }

    // MARK: saveData
    func saveData(host: String, login: String, password: String) {
        keychain[hostKey] = host
        keychain[loginKey] = login
        keychain[passwordKey] = password
    }
    
    // MARK: getHost
    func getHost() -> String? {
        return keychain[hostKey]
    }
    
    // MARK: getLogin
    func getLogin() -> String? {
        return keychain[loginKey]
    }
    
    // MARK: getPassword
    func getPassword() -> String? {
        return keychain[passwordKey]
    }

    // MARK: deleteCredentials
    func deleteCredentials() {
        try? keychain.remove(hostKey)
        try? keychain.remove(loginKey)
        try? keychain.remove(passwordKey)
    }
}
