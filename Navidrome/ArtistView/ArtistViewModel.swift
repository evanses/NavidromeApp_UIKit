final class ArtistViewModel {
    var artistId: String
    var artist: NavidromeArtistFull?
    
    init(artistId: String) {
        self.artistId = artistId
//        updateArtistInfo(for: artistId)
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
    
    func updateArtistInfo() {
        NavidromeApiManager.shared.fetchArtistFull(for: artistId) { result in
            switch result {
            case .success(let artist):
                self.artist = artist
                self.state = .loaded
            case .failure(let error):
                print("Error fetching in view model full artist info: \(error)")
            }
        }
    }
}

