//
//  DataPeliculaParticular.swift
//  Cine
//
//  Created by apple on 11/09/22.
//

import Foundation

struct Pelis: Decodable{
    let adult: Bool
    let backdrop_path, homepage, imdb_id, original_title, overview, poster_path: String
    let belongs_to_collection: String?
    let budget, id: Int
    let genres: [Genero]
    let original_language: String
}

struct Genero: Codable {
    let id: Int
    let name : String
}
