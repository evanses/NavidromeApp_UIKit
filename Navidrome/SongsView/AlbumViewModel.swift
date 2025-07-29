class AlbumViewModel {
    
    let albumId: String
    var albumFull: NavidromeAlbumFull?
    
    init(albumId: String) {
        self.albumId = albumId
    }
    
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
    
    func updateAlbumInfo() {
        NavidromeApiManager.shared.fetchAlbumFull(for: albumId){ result in
            switch result {
            case .success(let album):
                self.albumFull = album
                self.state = .loaded
            case .failure(let error):
                print("Error fetching in view model albums: \(error)")
            }
        }
    }
}


