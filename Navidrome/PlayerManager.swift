import AVFoundation
import Foundation

class PlayerManager {
    static let shared = PlayerManager()
    
    var isPlaying: Bool = false
    var currentSong: NavidromeSong?
    
    private init() {}
    
    private var player: AVPlayer?
    var delegate: MiniPlayerViewDelegate?
    
    func play(song: NavidromeSong) {
        if let currentSong = self.currentSong {
            if song.id == currentSong.id {
                if isPlaying {
                    player?.pause()
                    isPlaying = false
                    delegate?.updateView(song: song)
                } else {
                    player?.play()
                    isPlaying = true
                    delegate?.updateView(song: song)
                }
            } else {
                playNewSong(song: song)
            }
        } else {
            playNewSong(song: song)
        }
    }
    
    func playNewSong(song: NavidromeSong) {
        guard let apiHost = KeychainManager.shared.getHost(),
            let login = KeychainManager.shared.getLogin(),
            let pass = KeychainManager.shared.getPassword() else {
                return
            }

        guard let url = URL(string: "\(apiHost)/rest/stream.view?u=\(login)&p=\(pass)&v=1.15&c=iosApp&id=\(song.id)") else {
            return
        }

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPlaying = true
        currentSong = song
        delegate?.updateView(song: song)
    }
    
    func playPauseTapped() {
        if isPlaying {
            player?.pause()
            isPlaying = false
            
            if let song = currentSong {
                delegate?.updateView(song: song)
            }
        } else {
            player?.play()
            isPlaying = true
            
            if let song = currentSong {
                delegate?.updateView(song: song)
            }
        }
    }
}
