//
//  FuncionesGlobales.swift
//  Cine
//
//  Created by GrupoSalinasAlpha on 09/09/22.
//

import Foundation

//Funcion que toma los datos del api

func TodasLasPeliculas(genero: String, completion: @escaping (resultados) -> Void) {
    print(genero)
    let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=146780240fcf6b0a89bf2bdaa9cfd8c1&language=en-US&with_genres=" + genero)!

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            if let generosData = try? JSONDecoder().decode(resultados.self, from: data) {
                DispatchQueue.main.sync {
                    completion(generosData)
                    return
                }
            }
        }
    }.resume()
}

// Funcion de la api de generos
func TodasLosGeneros(completion: @escaping (Generos) -> Void){
    let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=146780240fcf6b0a89bf2bdaa9cfd8c1")!
    URLSession.shared.dataTask(with: url){
        data, response, error in
        if let data = data {
            if let messages = try? JSONDecoder().decode(Generos.self, from: data){
                completion(messages)
                return
            }
        }
    }.resume()
}

func fetchMessenges(completion: @escaping (Pelis) -> Void){
        let url = URL(string: "https://api.themoviedb.org/3/movie/333?language=en-US&api_key=7763fe7a16c2e76dc98726695e66252d")!
        URLSession.shared.dataTask(with: url){
            data, response, error in
            if let data = data {
                if let messages = try? JSONDecoder().decode(Pelis.self, from: data){
                    completion(messages)
                    return
                }
            }
        }.resume()
    }

func detectorDeGenero(x : Int) -> String{
    
    var idGenero: String = "18"
    let arregloDeGeneros = [28,12,16,35,80,99,18,10751,14,36,27,10402,9648,10749,878,10770,53,10752,37]
    for y in arregloDeGeneros {
        if x == y {
            idGenero = String(y)
        }
    }
    return idGenero
}
