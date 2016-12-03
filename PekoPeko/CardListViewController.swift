//
//  StoreListViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 08/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import CoreLocation
import DZNEmptyDataSet

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
    
    var cards = [Card]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var nextPage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewConfig() {
        tableView.register(UINib(nibName: EmptyTableViewCell.identify, bundle: nil), forCellReuseIdentifier: EmptyTableViewCell.identify)
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
    
    func reload() {
        tableView.reloadData()
    }
    
    func reloadAllCard() {
        cards.removeAll()
        nextPage = "0"
        getAllCard()
    }
    
    func getAllCard() {
        let cardRequest = CardRequest(location: userLocation ?? nil, nextPage: nextPage ?? nil)
        weak var _self = self
        CardStore.getAllCard(cardRequest: cardRequest) { (cardResponse, error) in
            if let _self = _self {
                if let refreshControl = _self.refreshControl {
                    refreshControl.endRefreshing()
                }
                guard error == nil else {
                    if let error = error as? ServerResponseError, let data = error.data {
                        let messageView = MessageView(frame: _self.view.bounds)
                        messageView.message = data[NSLocalizedFailureReasonErrorKey] as! String?
                        messageView.setButtonClose("Đóng", action: {
                            if !AuthenticationStore().isLogin {
                                HomeTabbarController.sharedInstance.logOut()
                            }
                        })
                        _self.addFullView(view: messageView)
                    }
                    return
                }
                
                if let cardResponse = cardResponse {
                    if let cards = cardResponse.cards {
                        _self.cards.append(contentsOf: cards)
                    }
                    if let pagination = cardResponse.pagination, let nextPage = pagination.nextPage {
                        _self.nextPage = nextPage
                    } else {
                        _self.nextPage = "NO"
                    }
                }
                
                _self.tableView.tag = 0
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
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identify, for: indexPath) as! CardTableViewCell
        cell.delegate = self
        cell.card = cards[indexPath.row]
        
        if nextPage != "NO" && self.tableView.tag == 0 && indexPath.row == cards.count - 1 {
            self.tableView.tag = 1
            getAllCard()
        }
        
        return cell
    }
}

extension CardListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconBearEmpty")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributedText = NSMutableAttributedString()
        let attribute1 = [NSFontAttributeName: UIFont.getBoldFont(12), NSForegroundColorAttributeName: UIColor.colorGray]
        let variety1 = NSAttributedString(string: "Danh sách Card của cửa hàng với\nvô vàn phần thưởng hấp dẫn", attributes: attribute1)
        attributedText.append(variety1)
        
        return attributedText
    }
}
