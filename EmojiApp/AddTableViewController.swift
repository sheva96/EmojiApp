//
//  AddTableViewController.swift
//  EmojiApp
//
//  Created by Yevhen Shevchenko on 08.12.2020.
//

import UIKit

class AddTableViewController: UITableViewController {
    
    var object = Emoji(emoji: "", name: "", description: "", isFavourite: false)
    
    @IBOutlet weak var emojiTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        updateSaveButtoneState()
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtoneState()
    }
    
    private func updateUI() {
        emojiTextField.text = object.emoji
        nameTextField.text = object.name
        descriptionTextField.text = object.description
    }
    
    private func updateSaveButtoneState() {
        let emojiText = emojiTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        
        saveButton.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveSegue" else { return }
        
        let emoji = emojiTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        
        self.object = Emoji(emoji: emoji, name: name, description: description, isFavourite: self.object.isFavourite)
    }
}
