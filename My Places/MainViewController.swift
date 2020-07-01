//
//  MainViewController.swift
//  My Places
//
//  Created by Smart Cash on 22.06.2020.
//  Copyright © 2020 Denis Svetlakov. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var places: Results<Places>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        places = realm.objects(Places.self)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = places[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
//        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (_, _, _) in
//            StorageManager.deleteObject(place)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
        let swipeActions = UISwipeActionsConfiguration (actions: [deleteAction])
        deleteAction.backgroundColor = .red
//        editAction.backgroundColor = .blue
        return swipeActions
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        cell.typeLabel.text = place.type
        cell.locationLabel.text = place.location
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditScreen" {
            guard let indexPatch = tableView.indexPathForSelectedRow else {return}
            let place = places[indexPatch.row]
            let newPlaceVC = segue.destination as! NewPlaceViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return}
        newPlaceVC.savePlace()
        tableView.reloadData()
    }

}
