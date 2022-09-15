//
//  DataGeneros.swift
//  Cine
//
//  Created by apple on 11/09/22.
//

import Foundation

struct Generos: Codable{
    let genres: [generosOpciones]
}

struct generosOpciones: Codable{
    let id: Int
    let name : String
}
