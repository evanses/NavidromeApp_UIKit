final class ArtistsViewModel {
    
    var artists: [NavidromeArtist] = []
    
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
    
    func updateArtists() {
        NavidromeApiManager.shared.fetchArtists { result in
            switch result {
            case .success(let artists):
                self.artists = artists
                self.state = .loaded
            case .failure(let error):
                print("Error fetching in view model artists: \(error)")
            }
        }
    }
}
