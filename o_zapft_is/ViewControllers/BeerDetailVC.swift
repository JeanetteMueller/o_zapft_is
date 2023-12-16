//
//  BeerDetailVC.swift
//  o_zapft_is
//
//  Created by Jeanette Müller on 15.12.23.
//

import UIKit

class BeerDetailImageCell: UITableViewCell {
    
    @IBOutlet var largeImageView: UIImageViewWithNetworker!
}
class BeerDetailDetailCell: UITableViewCell {
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
}
class BeerDetailLargeTextCell: UITableViewCell {
    
    @IBOutlet var largeTextLabel: UILabel!
}

class BeerDetailVC: UITableViewController, Storyboarded {
    weak var coordinator: RootCoordinator?
    
    var beer: BeerType?
    
    let content = [
        [BeerType.CodingKeys.imageUrl],
        [BeerType.CodingKeys.name],
         [BeerType.CodingKeys.desc],
        [BeerType.CodingKeys.abv, BeerType.CodingKeys.ibu, BeerType.CodingKeys.ebc, BeerType.CodingKeys.srm, BeerType.CodingKeys.ph]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(named: "MainBackgroundColor")
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.navigationItem.title = self.beer?.name ?? "–"
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.content.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.content[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerDetailDetailCell") as! BeerDetailDetailCell
        
        let rowContent = self.content[indexPath.section][indexPath.row]
        
        if let currentBeer = self.beer {
            
            switch rowContent {
                case .id:
                    break
                case .imageUrl:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BeerDetailImageCell", for: indexPath) as! BeerDetailImageCell
                    
                    if let imageUrlPath = currentBeer.imageUrl, let imageUrl = URL(string: imageUrlPath) {
                        cell.largeImageView.showImage(from: imageUrl)
                    }
                    
                    return cell
                case .name:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BeerDetailDetailCell", for: indexPath) as! BeerDetailDetailCell
                    cell.leftLabel?.text = rowContent.rawValue.localized
                    cell.rightLabel?.text = currentBeer.name
                    return cell
                case .desc:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BeerDetailLargeTextCell", for: indexPath) as! BeerDetailLargeTextCell
                    cell.largeTextLabel?.text = currentBeer.desc
                    return cell
                case .abv:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BeerDetailDetailCell", for: indexPath) as! BeerDetailDetailCell
                    cell.leftLabel?.text = rowContent.rawValue.localized
                    cell.rightLabel?.text = "\(currentBeer.abv ?? 0.0) "
                    return cell
                case .ibu:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BeerDetailDetailCell", for: indexPath) as! BeerDetailDetailCell
                    cell.leftLabel?.text = rowContent.rawValue.localized
                    cell.rightLabel?.text = "\(currentBeer.ibu ?? 0.0) "
                    return cell
                case .ebc:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BeerDetailDetailCell", for: indexPath) as! BeerDetailDetailCell
                    cell.leftLabel?.text = rowContent.rawValue.localized
                    cell.rightLabel?.text = "\(currentBeer.ebc ?? 0.0) "
                    return cell
                case .srm:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BeerDetailDetailCell", for: indexPath) as! BeerDetailDetailCell
                    cell.leftLabel?.text = rowContent.rawValue.localized
                    cell.rightLabel?.text = "\(currentBeer.srm ?? 0.0) "
                    return cell
                case .ph:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BeerDetailDetailCell", for: indexPath) as! BeerDetailDetailCell
                    cell.leftLabel?.text = rowContent.rawValue.localized
                    cell.rightLabel?.text = "\(currentBeer.ph ?? 0.0) "
                    return cell
                case .ingredients:
                    break
                case .foodPairing:
                    break
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowContent = self.content[indexPath.section][indexPath.row]
        if rowContent == .imageUrl {
            return 250
        }
        return UITableView.automaticDimension
    }
}
