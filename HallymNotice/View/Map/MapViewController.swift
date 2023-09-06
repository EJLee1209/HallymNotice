//
//  MapViewController.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/06.
//

import UIKit
import MapKit

class MapViewController: UIViewController, BaseViewController {
    
    //MARK: - Properties

    private let mapView: MKMapView = .init()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
            layout()
        
    }
    
    //MARK: - Helpers
    func layout() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind() {
        
    }
    
}
