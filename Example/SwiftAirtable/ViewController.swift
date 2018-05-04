//
//  ViewController.swift
//  SwiftAirtable
//
//  Created by nicolasnascimento on 04/19/2018.
//  Copyright (c) 2018 nicolasnascimento. All rights reserved.
//

import UIKit
import SwiftAirtable

class ViewController: UIViewController {
    
    // MARK: - Public
    
    // Generate this at https://api.airtable.com
    let apiKey = "YOUR_API_KEY"
    
    // The link to the base you want to fetch
    let apiBaseUrl = "https://api.airtable.com/v0/YOUR_API_BASE_URL"
    
    // The object schema to be used when fetching from Airtable
    let schema = AirtablePerson.schema
    
    // The name of the table inside the base
    let table = "Table 1"
    
    // MARK: - Outlets
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cool: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    
    // The component that adds a loading indicative to a view
    var loadingComponent: LoadingComponent!
}


extension ViewController {
    var airtable: Airtable {
        return Airtable(apiKey: self.apiKey, apiBaseUrl: self.apiBaseUrl, schema: self.schema)
    }
}

extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateAndReload(using: self.airtable)
    }
    
    // MARK: - Actions
    @IBAction func didPressReload(_ sender: UIBarButtonItem) {
        
        updateAndReload(using: self.airtable)
    }
    
}

// MARK: - Private
extension ViewController {
    
    private func updateAndReload(using airtable: Airtable) {
        self.loadingComponent = LoadingComponent(targetView: self.stackView)
        self.loadingComponent.addLoadingIndicator()
        
        let table = self.table
        airtable.fetchAll(table: table) { [weak self] (objects: [AirtablePerson], error: Error?) in
            
            DispatchQueue.main.async {
                self?.loadingComponent.removeLoadingIndicators()
            }
            
            if let error = error {
                print(error)
            } else {
                guard var person = objects.first else { return }
                
                self?.updateLabels(with: person)
                
                person.name = person.name == "John" ? "Alex" : "John"
                person.age = person.age == 22 ? 19 : 22
                person.photo.url = person.photo.fileName == "beach.jpg" ? "https://cdn.pixabay.com/photo/2017/03/15/09/01/crocus-2145543_1280.jpg" : "https://cdn.pixabay.com/photo/2018/01/05/02/40/background-3062011_1280.jpg"
                person.photo.fileName = person.photo.fileName == "beach.jpg" ? "crocus.jpg" : "beach.jpg"
                person.date = Date()
                person.cool = !person.cool
                
                airtable.updateObject(with: person, inTable: table) { object, error in
                    if let error = error {
                        print(error)
                    } else {
                        print(object ?? "object is nil")
                    }
                }
            }
        }
    }
    
    private func updateLabels(with person: AirtablePerson) {
        DispatchQueue.main.async { [weak self] in
            self?.name.text = person.name
            self?.age.text = person.age.description
            self?.date.text = person.date.description
            self?.cool.text = "Cool? " + ( person.cool ? "YES" : "NO")
        }
        
        guard let url = URL(string: person.photo.url) else { return }
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.photo.image = UIImage(data: data)
            }
        }
    }
}
