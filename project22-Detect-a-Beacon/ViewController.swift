//  ViewController.swift
//  project22-Detect-a-Beacon
//
//  Created by Nikita  on 7/25/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet var distanceLabel: UILabel!
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity){
        UIView.animate(withDuration: 1) { [unowned self] in
            switch distance {
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceLabel.text = "RIGHT HERE"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceLabel.text = "NEAR"
            case .far:
                self.view.backgroundColor = .blue
                self.distanceLabel.text = "FAR"
            case .unknown:
                self.view.backgroundColor = .gray
                self.distanceLabel.text = "UNKNOWN"
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first{
            update(distance: beacon.proximity)
        }
        else {
            update(distance: .unknown)
        }
    }


}

