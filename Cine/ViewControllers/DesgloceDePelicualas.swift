//
//  DesgloceDePelicualas.swift
//  Cine
//
//  Created by apple on 12/09/22.
//

import UIKit
import UserNotifications

let NotificacionPeliculasCompradas = "PeliculasTiket"

class DesgloceDePelicualas: UIViewController {
    

    var peliDesgloce : Movies?
    
    private let cache = NSCache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TituloPeliculaEspecifica.text = peliDesgloce?.original_title
        DescripcionPeliculaEspecifica.text = peliDesgloce?.overview
        // Do any additional setup after loading the view.
        
        if let name = peliDesgloce?.poster_path {
            let imageName = "https://image.tmdb.org/t/p/original" + name
            let cacheString = NSString(string: imageName)
            
            if let cacheImage = self.cache.object(forKey: cacheString) {
                ImagenPeliculasEspecifica.image = cacheImage
            } else {
                self.loadImage(from: URL(string: imageName)) { [weak self] (image) in
                    guard let self = self, let image = image else { return }
                    self.ImagenPeliculasEspecifica.image = image
              
                    self.cache.setObject(image, forKey: cacheString)
                }
            }
        
        }
    }
    
    @IBOutlet weak var ImagenPeliculasEspecifica: UIImageView!
    @IBOutlet weak var TituloPeliculaEspecifica: UILabel!
    @IBOutlet weak var DescripcionPeliculaEspecifica: UITextView!
    
    @IBAction func Aleta(_ sender: Any) {
        let center = UNUserNotificationCenter.current()

        showAlert(title: "alerta sismica", messeng: "Ya compro su boleto para: \(String(describing: peliDesgloce!.title))", hadlerOK: { action in

            self.navigationController?.popViewController(animated: true)
        })
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted{
                let notificationConten = UNMutableNotificationContent()
                notificationConten.title = "Felicidades su boleto se ha reservado correctamente"
                notificationConten.body = ("La pelicula es:"+self.peliDesgloce!.original_title)
                let date = Date().addingTimeInterval(5)
                let dateInFuture = Calendar.current.dateComponents([.second], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInFuture, repeats: true)
                let request = UNNotificationRequest(identifier: "PeliculasTiket", content: notificationConten, trigger: trigger)
                center.add(request) { (error) in
                }
            }else{
                print("NO DIO ACCESO")
            }
        }
        //NotificationCenter.default.addObserver( self, selector: #selector(notiEvent),name: NSNotification.Name(NotificacionPeliculasCompradas), object: nil)
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
    
    func showAlert(title: String, messeng: String, hadlerOK: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: messeng, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: hadlerOK)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc
        func notiEvent (notification: Notification){
        print("evento", notification)
        let valorDeLaNotificacion = notification.userInfo
        let Generos = valorDeLaNotificacion!["Generos"] as! generosOpciones
    }
}

    
