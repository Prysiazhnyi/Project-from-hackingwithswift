//
//  ViewController.swift
//  Project1
//
//  Created by Serhii Prysiazhnyi on 17.10.2024.
//

import UIKit

class ViewController: UITableViewController{
    var pictures = [ImageSave]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let defaults = UserDefaults.standard
        
        if let savedPictures = defaults.object(forKey: "picture") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([ImageSave].self, from: savedPictures)
                print("Загрузка с памяти")
            } catch {
                print("!!! Failed to load pictures")
            }
        } else {
            DispatchQueue.global().async {
                let fm = FileManager.default
                let path = Bundle.main.resourcePath!
                let items = try! fm.contentsOfDirectory(atPath: path)
                
                for item in items {
                    if item.hasPrefix("nssl") {
                        self.pictures.append(ImageSave(nameImage: item, viewCount: 0))
                        //self.pictures.append(item)
                    }
                }
                print("Выполнена загрузка по дефолту")
            }
        }
        DispatchQueue.main.async {
            // Сортировка и обновление UI на главном потоке
            self.pictures.sort { $0.nameImage < $1.nameImage }  // Сортировка по имени изображения
            self.tableView.reloadData() // Обновление таблицы после завершения загрузки
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        // Основной текст
        cell.textLabel?.text = pictures[indexPath.row].nameImage
        
        // Подзаголовок для каждой строки
        cell.detailTextLabel?.text = "Кол-во просмотров: \(pictures[indexPath.row].viewCount)"  // Пример текста подзаголовка
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Увеличиваем счетчик просмотров для выбранного изображения
        pictures[indexPath.row].viewCount += 1
        print(pictures[indexPath.row].viewCount)
        tableView.reloadData()
        save()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row].nameImage
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "picture")
            
            print("Сохранение \(pictures)" )
            
        } else {
            print("Failed to save pictures.")
        }
    }
    
}

