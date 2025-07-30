import Foundation
import UIKit

final class NavidromeApiManager {   
    static let shared = NavidromeApiManager()
    
    private init() {}
    
    // MARK: fetchImage
    func fetchImage(url: String, completion: @escaping ((Result<UIImage, NetworkError>) -> Void)) {
            guard let imageUrl = URL(string: url) else {
                print("when fetching image, url is not valid")
                completion(.failure(.urlNotValid))
                return
            }
            
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let error {
                    print("when fetching image, there is no internet")
                    completion(.failure(.notInternet))
                    print(error.localizedDescription)
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode != 200 {
                    print("when fetching image, response status code is not 200")
                    completion(.failure(.responseError))
                    return
                }
                
                guard let data else {
                    print("when fetching image, there is no data")
                    completion(.failure(.noData))
                    return
                }
                
                guard let uiImage = UIImage(data: data) else {
                    print("when fetching image, there is no data2 (in UIImage")
                    completion(.failure(.noData))
                    return
                }
                print("done fetching image ")
                completion(.success(uiImage))
            }.resume()
        }

    
    // MARK: fetchArtists
    func fetchArtists(completion: @escaping ((Result<[NavidromeArtist], NetworkError>) -> Void)) {
        guard let apiHost = KeychainManager.shared.getHost(),
            let login = KeychainManager.shared.getLogin(),
            let pass = KeychainManager.shared.getPassword() else {
                return
            }

        let uri = "\(apiHost)/rest/getArtists.view?u=\(login)&p=\(pass)&v=1.12.0&c=iosApp&f=json"
        
        guard let url = URL(string: uri) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in
            
            if let error {
                completion(.failure(.notInternet))
                print("when fetching artists list, not internet")
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("when fetching artists list, response status code is not 200")
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                print("when fetching artists list, no data")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let res = try decoder.decode(ArtistsNavidroveMainResponse.self, from: data)
                
                if res.subsonicResponse.status != "ok" {
                    if let navidromeError = res.subsonicResponse.error {
                        print("when fetching artists list message dont ok: \(navidromeError.message)")

                    }
                    completion(.failure(.smthWentWrong))
                }

                var artists = [NavidromeArtist]()
                
                if let secRes = res.subsonicResponse.artists {
                    secRes.index.forEach { i in
                        i.artist.forEach { artist in
                            artists.append(artist)
                        }
                    }
                } else {
                    print("when fetching artists list: res.subsonicResponse.artists is nil")
                    completion(.failure(.smthWentWrong))
                }
                print("fetched \(artists.count) artists info")
                completion(.success(artists))
                
            } catch (let error) {
                print(error)
                
                completion(.failure(.parsingError))
            }
            
        }.resume()
    }
    
    // MARK: fetchAlbums
    func fetchAlbums(completion: @escaping ((Result<[NavidroveAlbum], NetworkError>) -> Void)) {
        guard let apiHost = KeychainManager.shared.getHost(),
            let login = KeychainManager.shared.getLogin(),
            let pass = KeychainManager.shared.getPassword() else {
                return
            }

        let uri = "\(apiHost)/rest/getAlbumList.view?u=\(login)&p=\(pass)&v=1.12.0&c=iosApp&f=json&type=alphabeticalByName&size=200"
        
        guard let url = URL(string: uri) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in
            
            if let error {
                completion(.failure(.notInternet))
                print("when fetching albums list, not internet")
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("when fetching albums list, response status code is not 200")
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                print("when fetching albums list, no data")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let res = try decoder.decode(AlbumNavidroveMainResponse.self, from: data)
                
                if res.subsonicResponse.status != "ok" {
                    if let navidromeError = res.subsonicResponse.error {
                        print("when fetching albums list message dont ok: \(navidromeError.message)")

                    }
                    completion(.failure(.smthWentWrong))
                }
                
                var albums = [NavidroveAlbum]()
                
                if let secRes = res.subsonicResponse.albumList {
                    secRes.album.forEach { album in
                        albums.append(album)
                    }
                } else {
                    print("when fetching albums list: res.subsonicResponse.albumList is nil")
                    completion(.failure(.smthWentWrong))
                }
                print("fetched \(albums.count) albums info")
                completion(.success(albums))
                
            } catch (let error) {
                print(error)
                
                completion(.failure(.parsingError))
            }
            
        }.resume()
    }
    
    // MARK: fetchImage
    func fetchImage(coverArt: String, completion: @escaping ((Result<UIImage, NetworkError>) -> Void)) {
        guard let apiHost = KeychainManager.shared.getHost(),
            let login = KeychainManager.shared.getLogin(),
            let pass = KeychainManager.shared.getPassword() else {
                return
            }

        let imageUri = "\(apiHost)/rest/getCoverArt.view?u=\(login)&p=\(pass)&v=1.15&c=iosApp&id=\(coverArt)"
        
        guard let imageUrl = URL(string: imageUri) else {
//            print("when fetching image, url is not valid")
            completion(.failure(.urlNotValid))
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let error {
//                print("when fetching image, there is no internet")
                completion(.failure(.notInternet))
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
//                print("when fetching image, response status code is not 200")
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
//                print("when fetching image, there is no data")
                completion(.failure(.noData))
                return
            }
            
            guard let uiImage = UIImage(data: data) else {
//                print("when fetching image, there is no data2 (in UIImage")
                completion(.failure(.noData))
                return
            }
//            print("done fetching image ")
            completion(.success(uiImage))
        }.resume()
    }
    
    // MARK: fetchArtistFull
    func fetchArtistFull(for id: String, completion: @escaping ((Result<NavidromeArtistFull, NetworkError>) -> Void)) {
        guard let apiHost = KeychainManager.shared.getHost(),
            let login = KeychainManager.shared.getLogin(),
            let pass = KeychainManager.shared.getPassword() else {
                return
            }

        let uri = "\(apiHost)/rest/getArtist.view?u=\(login)&p=\(pass)&v=1.12.0&c=iosApp&f=json&id=\(id)"
        
        guard let url = URL(string: uri) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in
            
            if let error {
                completion(.failure(.notInternet))
                print("when fetching artists list, not internet")
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("when fetching artists list, response status code is not 200")
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                print("when fetching artists list, no data")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let res = try decoder.decode(NavidromeAtristFullMainResponse.self, from: data)
                
                if res.subsonicResponse.status != "ok" {
                    if let navidromeError = res.subsonicResponse.error {
                        print("when fetching artists list message dont ok: \(navidromeError.message)")
                    }
                    completion(.failure(.smthWentWrong))
                }
                
                if let secRes = res.subsonicResponse.artist {
                    completion(.success(secRes))
                } else {
                    print("when fetching artists list: res.subsonicResponse.artists is nil")
                    completion(.failure(.smthWentWrong))
                }
            } catch (let error) {
                print(error)
                
                completion(.failure(.parsingError))
            }
            
        }.resume()
    }

    // MARK: fetchAlbumFull
    func fetchAlbumFull(for id: String, completion: @escaping ((Result<NavidromeAlbumFull, NetworkError>) -> Void)) {
        guard let apiHost = KeychainManager.shared.getHost(),
            let login = KeychainManager.shared.getLogin(),
            let pass = KeychainManager.shared.getPassword() else {
                return
            }

        let uri = "\(apiHost)/rest/getAlbum.view?u=\(login)&p=\(pass)&v=1.12.0&c=iosApp&f=json&id=\(id)"
        
        guard let url = URL(string: uri) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in
            
            if let error {
                completion(.failure(.notInternet))
                print("when fetching artists list, not internet")
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("when fetching artists list, response status code is not 200")
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                print("when fetching artists list, no data")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let res = try decoder.decode(NavidromeAlbumtFullMainResponse.self, from: data)
                
                if res.subsonicResponse.status != "ok" {
                    if let navidromeError = res.subsonicResponse.error {
                        print("when fetching artists list message dont ok: \(navidromeError.message)")
                    }
                    completion(.failure(.smthWentWrong))
                }
                
                if let secRes = res.subsonicResponse.album {
                    completion(.success(secRes))
                } else {
                    print("when fetching artists list: res.subsonicResponse.album is nil")
                    completion(.failure(.smthWentWrong))
                }
            } catch (let error) {
                print(error)
                
                completion(.failure(.parsingError))
            }
            
        }.resume()
    }
    
    // MARK: loginCheck
    func loginCheck(host: String, login: String, password: String, completion: @escaping ((Result<NavidromePing, NetworkError>) -> Void)) {
        let uri = "\(host)/rest/getArtists.view?u=\(login)&p=\(password)&v=1.12.0&c=iosApp&f=json"
        
        guard let url = URL(string: uri) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in
            
            if let error {
                completion(.failure(.notInternet))
                print("when loginCheck, not internet")
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("when loginCheck, response status code is not 200")
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                print("when loginCheck, no data")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let res = try decoder.decode(NavidromePingResponse.self, from: data)
                
                if res.subsonicResponse.status == "ok" {
                    print("success login")
                    completion(.success(res.subsonicResponse))
                } else {
                    if let navidromeError = res.subsonicResponse.error {
                        if navidromeError.code == 40 {
                            completion(.failure(.wrongLoginOrPass))
                        } else {
                            print("when loginCheck message dont ok: \(navidromeError.message)")
                            completion(.failure(.smthWentWrong))
                        }

                    } else {
                        completion(.failure(.smthWentWrong))
                    }
                }
            } catch (let error) {
                print(error)
                
                completion(.failure(.parsingError))
            }
            
        }.resume()
    }
}
