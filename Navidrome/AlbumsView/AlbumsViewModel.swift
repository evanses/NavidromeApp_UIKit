class AlbumsViewModel {
    
    var albums: [NavidroveAlbum] = []
    
    enum State {
        case initing
//        case loadedSaved
        case loaded
        case error
    }
    var stateChanger: ((State) -> Void)?
    private var state: State = .initing {
        didSet {
            stateChanger?(state)
        }
    }
    
    func updateAlbums() {
        NavidromeApiManager.shared.fetchAlbums { result in
            switch result {
            case .success(let albums):
                self.albums = albums
                self.state = .loaded
            case .failure(let error):
                print("Error fetching in view model albums: \(error)")
            }
        }
    }
}

