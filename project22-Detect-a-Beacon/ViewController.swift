//  ViewController.swift
//  project22-Detect-a-Beacon
//
//  Created by Nikita  on 7/25/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let beaconIDs = ["E2C56DB5-DFFB-48D2-BO60-D0F5A71096ED", "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", "74278BDA-B644-4520-8F0C-720EAF059935"]
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var beaconIDLabel: UILabel!
    @IBOutlet var circleView: UIView!
    var locationManager: CLLocationManager!
    var isDetected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        circleView.layer.cornerRadius = 50
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    startScanning()
                }
            }
        }
    }
    
    
    func startScanning(){
      
        let beaconRegion = CLBeaconRegion(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 456, identifier: "MyBeacon")
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
        
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first{
            if isDetected == false{
                let ac = UIAlertController(title: "A beacon  '\(beacon.uuid)' was deteted.", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                isDetected = true
                beaconIDLabel.text = beacon.uuid.uuidString
            }
            update(distance: beacon.proximity)
        }
        else {
            isDetected = false
            update(distance: .unknown)
        }
    }
    
    func update(distance: CLProximity){
        UIView.animate(withDuration: 1) { [unowned self] in
            switch distance {
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceLabel.text = "RIGHT HERE"
                circleView.transform = CGAffineTransform(scaleX: 3, y: 3)
             
            case .near:
                self.view.backgroundColor = .orange
                self.distanceLabel.text = "NEAR"
                circleView.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            case .far:
                self.view.backgroundColor = .blue
                self.distanceLabel.text = "FAR"
                circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
              
            case .unknown:
                self.view.backgroundColor = .gray
                self.distanceLabel.text = "UNKNOWN"
                circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
            @unknown default:
                fatalError()
            }
        }
    }


}

