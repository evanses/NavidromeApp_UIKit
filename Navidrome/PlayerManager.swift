import AVFoundation
import Foundation
import MediaPlayer

class PlayerManager {
    static let shared = PlayerManager()
    
    var isPlaying: Bool = false
    var currentSong: NavidromeSong?
    
    private init() {
        setupRemoteCommandCenter()
    }
    
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
        updateNowPlayingInfo(song: song)
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
    
    private func updateNowPlayingInfo(song: NavidromeSong) {
        guard let currentItem = player?.currentItem else { return }
        let asset = currentItem.asset
        
        Task {
            var nowPlayingInfo: [String: Any] = [
                MPMediaItemPropertyTitle: song.title,
                MPMediaItemPropertyArtist: song.artist,
                MPMediaItemPropertyAlbumTitle: song.album
            ]
            
            do {
                let duration = try await asset.load(.duration)
                let seconds = CMTimeGetSeconds(duration)
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = seconds
            } catch {
                print("Failed to load duration: \(error)")
            }

            do {
                let coverArtImage = try await NavidromeApiManager.shared.fetchImageAsync(coverArt: song.coverArt)
                let artwork = MPMediaItemArtwork(boundsSize: coverArtImage.size) { _ in coverArtImage }
                nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
            } catch {
                print("Error loading coverArt")
            }

            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }

    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.player?.play()
            self?.isPlaying = true
            if let song = self?.currentSong {
                self?.delegate?.updateView(song: song)
            }
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.player?.pause()
            self?.isPlaying = false
            if let song = self?.currentSong {
                self?.delegate?.updateView(song: song)
            }
            return .success
        }

        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.playPauseTapped()
            return .success
        }
    }


}
