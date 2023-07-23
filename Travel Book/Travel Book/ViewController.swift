//
//  ViewController.swift
//  Travel Book
//
//  Created by midDeveloper on 27.06.2023.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
            
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchCoords = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            print(touchCoords)
            chosenLatitude = touchCoords.latitude
            chosenLongitude = touchCoords.longitude
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = touchCoords
            annotation.title = nameText.text
            annotation .subtitle = commentText.text
            self.mapView.addAnnotation(annotation)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coords = locations[0].coordinate
        let location = CLLocationCoordinate2D(latitude: coords.latitude , longitude: coords.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        print("deneme")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        
        newPlace.setValue(UUID(), forKey: "id")
        newPlace.setValue(nameText.text, forKey: "title")
        newPlace.setValue(commentText.text, forKey: "subTitle")
        newPlace.setValue(chosenLatitude, forKey: "latitude")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        
        do{
            try context.save()
            print("save")
        }catch{
            print("error")
        }
        
        
    }
    
}

