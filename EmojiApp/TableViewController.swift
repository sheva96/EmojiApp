//
//  TableViewController.swift
//  EmojiApp
//
//  Created by Yevhen Shevchenko on 08.12.2020.
//

import UIKit

class TableViewController: UITableViewController {
    
    var objects = [
        Emoji(emoji: "🇦🇹", name: "Austria", description: "1", isFavourite: false),
        Emoji(emoji: "🇫🇮", name: "Finland", description: "2", isFavourite: false),
        Emoji(emoji: "🇧🇬", name: "Bulgaria", description: "3", isFavourite: false),
        Emoji(emoji: "🇺🇦", name: "Ukraine", description: "4", isFavourite: false),
        Emoji(emoji: "🇷🇺", name: "Russia", description: "5", isFavourite: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Emoji"
        navigationItem.leftBarButtonItem = editButtonItem
        
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
        /*
         guard segue.identifier == "saveSegue" else { return }
         guard let sourceVC = segue.source as? AddTableViewController else { return }
         let object = sourceVC.object
         
         if let selectedIndexPath = tableView.indexPathForSelectedRow {
         objects[selectedIndexPath.row] = object
         tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
         } else {
         let indexPath = IndexPath(row: objects.count, section: 0)
         objects.append(object)
         tableView.insertRows(at: [indexPath], with: .automatic)
         }
         */
        
        if segue.identifier == "saveSegue", let sourceVC = segue.source as? AddTableViewController {
            let object = sourceVC.object
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                objects[selectedIndexPath.row] = object
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            } else {
                let indexPath = IndexPath(row: objects.count, section: 0)
                objects.append(object)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        } else if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: false)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "editEmoji" else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let object = objects[indexPath.row]
        
        guard let navigaionVC = segue.destination as? UINavigationController else { return }
        guard let addTableVC = navigaionVC.topViewController as? AddTableViewController else { return }
        addTableVC.object = object
        addTableVC.title = "Edit"
    }
    
    // MARK: - Private methods
    
    private func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion) in
            self.objects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .systemGreen
        action.image = UIImage(systemName: "checkmark.circle")
        return action
    }
    
    private func favouriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = objects[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Favourite") { (action, view, completion) in
            object.isFavourite = !object.isFavourite
            self.objects[indexPath.row] = object
            completion(true)
        }
        action.backgroundColor = object.isFavourite ? .systemPurple : .systemGray
        action.image = UIImage(systemName: "heart")
        return action
    }
}

// MARK: - Table view data source

extension TableViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objects.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! TableViewCell
        
        let object = objects[indexPath.row]
        
        /*
         cell.emojiLabel.text = object.emoji
         cell.nameLabel.text = object.name
         cell.descriptionLabel.text = object.description
         
         var content = cell.defaultContentConfiguration()
         content.text = "\(indexPath.section)"
         cell.contentConfiguration = content
         */
        
        cell.set(object: object)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = objects.remove(at: sourceIndexPath.row)
        objects.insert(movedEmoji, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Countries" : nil
    }
}

// MARK: - Table view delegate

extension TableViewController {
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let favourite = favouriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done, favourite])
    }
}

