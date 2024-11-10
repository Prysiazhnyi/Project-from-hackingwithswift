//
//  ViewController.swift
//  Project1
//
//  Created by Serhii Prysiazhnyi on 17.10.2024.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global().async {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    self.pictures.append(item)
                }
            }
            // Сортировка и обновление UI на главном потоке
            self.pictures.sort()
            print("Pictures loaded: \(self.pictures)") // Проверка загрузки
            
            DispatchQueue.main.async {
                self.tableView.reloadData() // Обновление таблицы после завершения загрузки
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
      
        // Основной текст
                cell.textLabel?.text = pictures[indexPath.row]
                
                // Подзаголовок для каждой строки
                cell.detailTextLabel?.text = "Описание для \(pictures[indexPath.row])"  // Пример текста подзаголовка
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

