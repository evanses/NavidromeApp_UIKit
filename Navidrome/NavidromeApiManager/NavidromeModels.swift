struct NavidromeSong: Codable {
    let id: String
    let title: String
    let album: String
    let artist: String
    let year: Int?
    let coverArt: String
    let duration: Int
    let bitRate: Int
}

struct NavidromeArtist: Codable {
    let id: String
    let name: String
    let albumCount: Int
    let coverArt: String
    let artistImageUrl: String
    let sortName: String
    
    init(
        id: String,
        name: String,
        albumCount: Int,
        coverArt: String,
        artistImageUrl: String,
        sortName: String
    ) {
        self.id = id
        self.name = name
        self.albumCount = albumCount
        self.coverArt = coverArt
        self.artistImageUrl = artistImageUrl
        self.sortName = sortName
    }
}

struct ArtistsNavidromeArtistsSecondResponse: Codable {
    let name: String
    let artist: [NavidromeArtist]
}

struct ArtistsNavidromeArtistsResponse: Codable {
    let index: [ArtistsNavidromeArtistsSecondResponse]
}

struct NavidroveError: Codable {
    let code: Int
    let message: String
}

struct ArtistsNavidromeSecondRepsonse: Codable {
    let status: String
    let artists: ArtistsNavidromeArtistsResponse?
    let error: NavidroveError?
}

struct ArtistsNavidroveMainResponse: Codable {
    let subsonicResponse: ArtistsNavidromeSecondRepsonse
    
    private enum CodingKeys: String, CodingKey {
        case subsonicResponse = "subsonic-response"
    }
}


struct NavidroveAlbum: Codable {
    let id: String
//    let title: String
    let name: String
//    let album: String
//    let artist: String
//    let year: Int
//    let genre: String
    let coverArt: String
//    let created": "2024-09-30T22:34:42.742285431+05:00",
    let artistId: String
    let songCount: Int
    let sortName: String
    
    init(
        id: String,
//        title: String,
        name: String,
//        album: String,
//        artist: String,
//        year: Int,
//        genre: String,
        coverArt: String,
        artistId: String,
        songCount: Int,
        sortName: String
    ) {
        self.id = id
//        self.title = title
        self.name = name
//        self.album = album
//        self.artist = artist
//        self.year = year
//        self.genre = genre
        self.coverArt = coverArt
        self.artistId = artistId
        self.songCount = songCount
        self.sortName = sortName
    }
}

struct AlbumNavidromePreResponse: Codable {
    let album: [NavidroveAlbum]
}

struct AlbumNavidromeResponse: Codable {
    let status: String
    let albumList: AlbumNavidromePreResponse?
    let error: NavidroveError?
}

struct AlbumNavidroveMainResponse: Codable {
    let subsonicResponse: AlbumNavidromeResponse
    
    private enum CodingKeys: String, CodingKey {
        case subsonicResponse = "subsonic-response"
    }
}



struct NavidromeArtistFull: Codable {
    let id: String
    let name: String
    let albumCount: Int
    let coverArt: String
    let artistImageUrl: String
    let sortName: String
    let album: [NavidroveAlbum]
    
    init(
        id: String,
        name: String,
        albumCount: Int,
        coverArt: String,
        artistImageUrl: String,
        sortName: String,
        album: [NavidroveAlbum]
    ) {
        self.id = id
        self.name = name
        self.albumCount = albumCount
        self.coverArt = coverArt
        self.artistImageUrl = artistImageUrl
        self.sortName = sortName
        self.album = album
    }
}

struct NavidromeAtristFullPreRespone: Codable {
    let status: String
    let artist: NavidromeArtistFull?
    let error: NavidroveError?
}

struct NavidromeAtristFullMainResponse: Codable {
    let subsonicResponse: NavidromeAtristFullPreRespone
    
    private enum CodingKeys: String, CodingKey {
        case subsonicResponse = "subsonic-response"
    }
}




struct NavidromeAlbumFull: Codable {
    let id: String
    let name: String
    let artistId: String
    let coverArt: String
    let sortName: String
    let song: [NavidromeSong]
}

struct NavidromeAlbumFullPreRespone: Codable {
    let status: String
    let album: NavidromeAlbumFull?
    let error: NavidroveError?
}

struct NavidromeAlbumtFullMainResponse: Codable {
    let subsonicResponse: NavidromeAlbumFullPreRespone
    
    private enum CodingKeys: String, CodingKey {
        case subsonicResponse = "subsonic-response"
    }
}
