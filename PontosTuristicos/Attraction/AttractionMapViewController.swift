//
//  File.swift
//  PontosTuristicos
//
//  Created by Lilian Tatsumy Yamamoto Kishi on 21/08/19.
//  Copyright © 2019 Satoru Kishi. All rights reserved.
//

import UIKit
import MapKit

class AttractionMapViewController: UIViewController {
    
    @IBOutlet weak var mapview: MKMapView!
    
    //Array que irá conter nossos pontos de interesse
    var poiAnnotations: [MKPointAnnotation] = []
    
    //CLLocationManager é a classe que nos dá acesso aos dados de localização
    lazy var locationManager: CLLocationManager = CLLocationManager()
    
    //Variável que receberá a atração selecionada na tabela
    var attraction: Attraction!
    
    // MARK: Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Definindo a nossa classe como delegate do mapview
        mapview.delegate = self
        
        self.title = attraction.title
        
        addAttraction()
        
        //Solicitando autorização do usuário para acesso à sua locaização
        requestUserLocationAuthorization()
    }
    
    func requestUserLocationAuthorization() {
        
        //Primeiro avaliamos se o device possui os serviços de localização habilitados
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self     //Definindo o deleate
            
            //Ajustando o nível de precisão.
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.allowsBackgroundLocationUpdates = true
            
            //A linha abaixo ajuda na performance da bateria, pois os updates de localização são
            //pausados conforme o sistema ache necessário
            locationManager.pausesLocationUpdatesAutomatically = true
            
            //Analisamos o status da autorização. Caso ainda não tenha autorizado, solicitamos
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Usuário já autorizou o acesso à sua localização")
            case .denied:
                print("Usuário negou o acesso à localização")
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()    //Solicitando autorização
            case .restricted:
                print("Este device não está habilitado a usar geolocalização")
            }
        } else {
            print("Você não possui os serviços de localização habilitados nesse device")
        }
    }
    
    //Método que adiciona as annotations no mapa
    func addAttraction() {
        
        //Criamos a requisição com as informações que serão passadas à Apple sobre o que queremos buscar
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = attraction.title   //Definindo o que estamos procurando
        request.region = mapview.region                 //E em qual região do mapa
        
        let search = MKLocalSearch(request: request)    //Objeto que fará a pesquisa junto à Apple
        search.start { (response: MKLocalSearch.Response?, error: Error?) in
            if error == nil {
                guard let response = response else {return} //Resposta da pesquisa
                DispatchQueue.main.async {                  //Retornando na thread principal
                    
                    //Antes de adicionar os pontos, removemos os que adicionados em pesquisas anteriores
                    self.mapview.removeAnnotations(self.poiAnnotations)
                    self.poiAnnotations.removeAll()
                    
                    for item in response.mapItems { //Percorrendo todos os itens da resposta
                        
                        //Criando as annotations. Neste caso, criamos como MKPointAnnotation
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        annotation.subtitle = item.phoneNumber
                        self.poiAnnotations.append(annotation)
                    }
                    self.mapview.addAnnotations(self.poiAnnotations)
                    
                    
                    let region = MKCoordinateRegion(center: self.poiAnnotations[0].coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                    self.mapview.setRegion(region, animated: true)
                }
            }
        }
        
        //Mostrando a região so mapa que engloba as annotations inseridas
        self.mapview.showAnnotations(self.mapview.annotations, animated: true)
        
    }
    
    //Dessa forma, podemos voltar à tela anterior
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
}





extension AttractionMapViewController: MKMapViewDelegate {
    
    //Método que desenha os overlays sobre o mapa
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        //Analisando se o Overlay é do tipo MKPolyline, que é o tipo enviado pela rota
        if overlay is MKPolyline {
            let renderer  = MKPolylineRenderer(overlay: overlay)    //Criando o renderer para o Overlay
            renderer.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)      //Definindo sua cor
            renderer.lineWidth = 6.0       //Espessura da linha
            return renderer
        } else {
            //Se não for uma Polylina, retornamos um Overlay padrão
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    //Método responsável por definir a view que será usada na annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //Criamos uma MKAnnotationView
        var annotationView: MKAnnotationView!
        
        //Validamos se a annotation é uma AttractionAnnotation antes de definir sua view
        if annotation is AttractionAnnotation {
            
            //Este método recupera uma annotation que já foi utilizada caso esteja disponível
            //Para isso, usamos um identificador, que no nosso caso será "Theater"
            annotationView = mapview.dequeueReusableAnnotationView(withIdentifier: "Attraction")
            
            //Se não tiver, criamos uma
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Attraction")
                
                //Propriedade que indica se iremos mostrar o balão ao clicar na annotation
                annotationView.canShowCallout = true
                
            } else {
                
                //Caso a view já exista, atualizamos a sua propriedade annotation
                annotationView.annotation = annotation
            }
            return annotationView
            
            //Caso a annotation seja do tipo MKPointAnnotation, trabalhamos seu visual
        }  else if annotation is MKPointAnnotation {
            
            //Tentando recuperar uma reutilizável através do identificador "POI"
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "POI")
            if annotationView == nil {
                
                //Se não existir, criarmos uma nova. A view de uma PointAnnotation é MKPinAnnotationView
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "POI")
                (annotationView as! MKPinAnnotationView).canShowCallout = true
                (annotationView as! MKPinAnnotationView).pinTintColor = .blue   //Mudando a cor
                (annotationView as! MKPinAnnotationView).animatesDrop = true    //Mostrando com animação
            } else {
                annotationView?.annotation = annotation
            }
        }
        return annotationView
    }
    
    //Método chamado quando usuário toca em um callout
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
}


extension AttractionMapViewController: CLLocationManagerDelegate {
    
    //Este método é chamado sempre que é recebido ou alterado o status de autorização
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //Caso o usuário tenha autorizado, mostramos a sua lozalização no mapa
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapview.showsUserLocation = true
        default:
            break
        }
    }
    
    //Método chamado sempre que o usuário altera a sua localização
    //e o mapa está definido para mostrar a localização so usuário
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
}
