//
//  ViewController.swift
//  Cine
//
//  Created by apple on 09/09/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    
    //Variables globales
    var generos: Generos?
    var generofalso = Generos.init(genres: [generosOpciones]())
    
    var Pelicula: resultados?
    var pasoMovies: Movies?
    
    var cambiogeneros: Int = 28
    var MuestraAlgo: Int = 0
    
    private let cache = NSCache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.SeleccionGenero.register(UINib(nibName: "Generico", bundle: nil), forCellWithReuseIdentifier: "CeldaGenero")
        self.SeleccionGenero.dataSource = self
        self.SeleccionGenero.delegate = self
        
        self.MuestraPeliculas.register(UINib(nibName: "PeliculasNews", bundle: nil), forCellWithReuseIdentifier: "CeldaPeliculas")
        self.MuestraPeliculas.dataSource = self
        self.MuestraPeliculas.delegate = self
       
        
        TodasLasPeliculas(genero: String(cambiogeneros)) { respuesta in
            self.Pelicula = respuesta
            print("-------------------------------------------------------------------------")
            print(respuesta.results.count)
            DispatchQueue.main.async { () -> Void in
                self.MuestraPeliculas.reloadData()
            }
        }
        
        TodasLosGeneros(completion:{ resultado in
            self.generos = resultado
            print(resultado.genres.count,  "------------------------------------------------------------------------")
            DispatchQueue.main.async { () -> Void in
                self.SeleccionGenero.reloadData()
            }
        })
    }
    //Todo lo arrastado del storyboard
    @IBOutlet weak var SeleccionGenero: UICollectionView!
    @IBOutlet weak var MuestraPeliculas: UICollectionView!
    @IBOutlet weak var FotoPeliRanket: UIImageView!
    
    //Funciones Necesarias
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == SeleccionGenero{
            return (self.generos?.genres.count) ?? 0
        }
        return (self.Pelicula?.results.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       let celdaMovie = self.MuestraPeliculas.dequeueReusableCell(withReuseIdentifier: "CeldaPeliculas", for: indexPath) as? PeliculasNews

        let pelis = Pelicula?.results[indexPath.row]
        
        if let name = pelis?.poster_path {
            let imageName = "https://image.tmdb.org/t/p/original" + name
            let cacheString = NSString(string: imageName)
            
            if let cacheImage = self.cache.object(forKey: cacheString) {
                celdaMovie?.ImagenPelis.image = cacheImage
            } else {
                self.loadImage(from: URL(string: imageName)) { [weak self] (image) in
                    guard let self = self, let image = image else { return }
                    celdaMovie?.ImagenPelis.image = image
                    self.cache.setObject(image, forKey: cacheString)
                }
            }
        }
        celdaMovie?.TituloPelis.text = pelis?.original_title
        celdaMovie?.Boton1.text = String(pelis?.popularity ?? 0)

        if collectionView == SeleccionGenero{
            let celdaGenero = self.SeleccionGenero.dequeueReusableCell(withReuseIdentifier: "CeldaGenero", for: indexPath) as? Generico
            let MuestraGenerosDatos = generos?.genres[indexPath.row]
            celdaGenero?.Label.text = MuestraGenerosDatos?.name
            return celdaGenero!
        }
        return celdaMovie!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == SeleccionGenero{
            let g = generos!.genres[indexPath.row]
            print(g)
            cambiogeneros = g.id
            let nada = detectorDeGenero(x: cambiogeneros)
            
            TodasLasPeliculas(genero: nada) { respuesta in
                self.Pelicula = respuesta
                DispatchQueue.main.async { () -> Void in
                    self.MuestraPeliculas.reloadData()
                }
            }
        }
        
        if collectionView == MuestraPeliculas{
            pasoMovies = Pelicula!.results[indexPath.row]
            performSegue(withIdentifier: "PasoInfo", sender: self)
        }
    }
    
    @IBAction func AllMoviesSee(_ sender: Any) {
        TodasLasPeliculas(genero: "28") { respuesta in
            self.Pelicula = respuesta
            let imagenNiños = self.Pelicula?.results[0]
           
            if let name = imagenNiños?.poster_path {
                let imageName = "https://image.tmdb.org/t/p/original" + name
                let cacheString = NSString(string: imageName)
                if let cacheImage = self.cache.object(forKey: cacheString) {
                    self.FotoPeliRanket.image = cacheImage
                } else {
                    self.loadImage(from: URL(string: imageName)) { [weak self] (image) in
                        guard let self = self, let image = image else { return }
                        self.FotoPeliRanket.image = image
                        self.cache.setObject(image, forKey: cacheString)
                    }
                }
            }
            DispatchQueue.main.async { () -> Void in
                self.MuestraPeliculas.reloadData()
            }
            TodasLosGeneros(completion:{ resultado in
                self.generos = resultado
                DispatchQueue.main.async { () -> Void in
                    self.SeleccionGenero.reloadData()
                }
            })
        }
    }
    
    @IBAction func OnlyKids(_ sender: Any) {
        TodasLasPeliculas(genero: "16") { respuesta in
            self.Pelicula = respuesta
            let imagenNiños = self.Pelicula?.results[0]
           
            if let name = imagenNiños?.poster_path {
                let imageName = "https://image.tmdb.org/t/p/original" + name
                let cacheString = NSString(string: imageName)
                if let cacheImage = self.cache.object(forKey: cacheString) {
                    self.FotoPeliRanket.image = cacheImage
                } else {
                    self.loadImage(from: URL(string: imageName)) { [weak self] (image) in
                        guard let self = self, let image = image else { return }
                        self.FotoPeliRanket.image = image
                        self.cache.setObject(image, forKey: cacheString)
                    }
                }
            }
            DispatchQueue.main.async { () -> Void in
                self.MuestraPeliculas.reloadData()
            }
            self.generos = self.generofalso
            DispatchQueue.main.async { () -> Void in
                self.SeleccionGenero.reloadData()
            }
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DesgloceDePelicualas {
            vc.peliDesgloce = pasoMovies
            }
    }
    @objc
        func notiEvent(notification: Notification){
        print("evento", notification)
        let valorDeLaNotificacion = notification.userInfo
    }
    
    private func loadImage(from url: URL?, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            guard let data = try? Data(contentsOf: url!) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}


    

