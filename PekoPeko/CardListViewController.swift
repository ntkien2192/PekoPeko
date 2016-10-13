//
//  StoreListViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 08/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import CoreLocation

protocol CardListViewControllerDelegate: class {
    func buttonCardTapped(card: Card?)
}

class CardListViewController: BaseViewController {
    
    weak var delegate: CardListViewControllerDelegate?
    
    static let storyboardName = "Card"
    static let identify = "StoreListViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    let locationManager = CLLocationManager()
    var userLocation: Location?
    
    var cards: [Card]? {
        didSet {
            if cards != nil {
                tableView.reloadData()
            }
        }
    }
    
    var nextPage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewConfig() {
        
        tableView.register(UINib(nibName: CardTableViewCell.identify, bundle: nil), forCellReuseIdentifier: CardTableViewCell.identify)
        tableView.tableFooterView = UIView()
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(CardListViewController.reloadAllCard), for: .valueChanged)
            tableView.addSubview(refreshControl)
            tableView.sendSubview(toBack: refreshControl)
        }
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func reloadAllCard() {
        nextPage = "0"
        getAllCard()
    }
    
    func getAllCard() {
        let cardRequest = CardRequest(location: userLocation ?? nil, nextPage: nextPage ?? nil)
        CardStore.getAllCard(cardRequest: cardRequest) { (cardResponse, error) in
            if let refreshControl = self.refreshControl{
                refreshControl.endRefreshing()
            }
            guard error == nil else {
                return
            }
            
            if let cardResponse = cardResponse {
                if let cards = cardResponse.cards {
                    self.cards = cards
                }
                if let pagination = cardResponse.pagination, let nextPage = pagination.nextPage {
                    self.nextPage = nextPage
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CardListViewController: CardTableViewCellDelegate {
    func cellTapped(card: Card?) {
        delegate?.buttonCardTapped(card: card)
    }
}

extension CardListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let location = locations[0]
        userLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}

extension CardListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cards = cards {
            return cards.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identify, for: indexPath) as! CardTableViewCell
        cell.delegate = self
        if let cards = cards {
            cell.card = cards[indexPath.row]
        }
        return cell
    }
}
