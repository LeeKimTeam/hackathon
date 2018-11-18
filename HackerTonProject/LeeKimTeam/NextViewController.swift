//
//  ViewController.swift
//  StanfordFaker
//
//  Created by qbbang on 16/11/2018.
//  Copyright © 2018 qbbang. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class NextViewController: UIViewController {
  
  @IBOutlet private weak var countLabel: UILabel?
  @IBOutlet private weak var mapView: MKMapView!
  private var locationManager = CLLocationManager()
  var firstBool = true
  
  var seconds = 30000
  var timer = Timer()
  var isTimerRunning = false
  var resumeTapped = false
  var buttoniBool = false
  var cctvButton = false
  var count = ViewController.info.latitude.count
  var cctvArray: [MKPointAnnotation] = []
  
  var globalRetion: MKCoordinateRegion? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    checkAuthorizationStatus()
    mapView.showsUserLocation = true
    mapView.mapType = .standard
    
    addpharmacy()
    addCamera()
    
  }
  
  private func addpharmacy() {
//    let  pharmacy = MKPointAnnotation()
    let pharmacy = MKPointAnnotation()
    pharmacy.coordinate = CLLocationCoordinate2D(latitude: 37.4954650, longitude: 127.0388456)
    pharmacy.title = "약국"
    
    mapView.addAnnotation(pharmacy)
  }
  private func addCamera() {
//    print("addCamera Start")
    for index in 0..<count {
      let cctv = MKPointAnnotation()
      cctv.coordinate = CLLocationCoordinate2D(
        latitude: Double(ViewController.info.latitude[index])!,
        longitude: Double(ViewController.info.longitude[index])!
      )
      cctv.title = "단속카메라"
      cctvArray.append(cctv)
      
    }
    
//    print("addCamera End")
  }
  
  private func checkAuthorizationStatus() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    //            locationManager.requestAlwaysAuthorization()
    case . restricted, .denied:
      break
    case .authorizedWhenInUse:
      fallthrough
    case .authorizedAlways:
      locationManager.startUpdatingLocation()
//      locationManager.startUpdatingLocation()
    }
  }
  @IBAction func currentLocation(_ sender: Any) {
    
    mapView.setRegion(globalRetion!, animated: true)
  }
  
  @IBAction func cctvButton(_ sender: Any) {
    cctvButton.toggle()
    if cctvButton {
      
      let camera12 = MKPointAnnotation()
      camera12.coordinate = CLLocationCoordinate2D(latitude: 37.495505, longitude: 127.038168)
      camera12.title = "단속카메라"
      mapView.addAnnotation(camera12)
      let camera13 = MKPointAnnotation()
      camera13.coordinate = CLLocationCoordinate2D(latitude: 37.495859, longitude: 127.039266)
      camera13.title = "단속카메라"
      mapView.addAnnotation(camera13)
      
//      print("button start:")
      
      for index in 0..<count {

        mapView.addAnnotation(cctvArray[index])
      }
//      print("button end:")
      
    } else if cctvButton == false {
      mapView.removeAnnotations(mapView.annotations)
    }
  }
  
  @IBAction func countStartButton(_ sender: UIButton) {
    buttoniBool.toggle()
    if buttoniBool {
      runTimer()
    } else if buttoniBool == false {
      reset()
    }
  }
  
  func reset() {
    timer.invalidate()
    seconds = 30000
    countLabel?.text = "Restart 300 sec"
  }
  
  func runTimer() {
    timer = Timer.scheduledTimer(timeInterval: 0.001,
                                 target: self, selector: #selector(NextViewController.updateTimer), userInfo: nil, repeats: true)
    isTimerRunning = true
    
  }
  
  func timeString(time: TimeInterval) -> String {
    let hours = Int(time) / 360000
    let minutes = Int(time) / 6000 % 6000
    let seconds = Int(time) & 6000
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
  }
  
  @objc func updateTimer() {
    if seconds < 1 {
      timer.invalidate()
      countLabel?.text = "Oh My God!!"
    } else {
      seconds -= 1
      countLabel?.text = timeString(time: TimeInterval(seconds))
    }
  }
  
}
extension NextViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let current = locations.last!
//    currentLocation = current
    
    let coordinate = current.coordinate
//    globalCoordinate = coordinate
    let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
//    globalspan = span
    let region = MKCoordinateRegion(center: coordinate, span: span)
    globalRetion = region
    
    
    if firstBool {
      mapView.setRegion(region, animated: true)
      firstBool = false
    } else {
      print("firstBool = false")
    }
  }
  
}

