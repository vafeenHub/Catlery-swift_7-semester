//
//  CatsViewController.swift
//  Catlery
//
//  Created by xcode on 20.11.2025.
//  Copyright © 2025 vsu. All rights reserved.
//

import UIKit

class CatsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
    
    private func setupUI() {
        title = "Котолерея"
        
        
        let testButton = UIBarButtonItem (
            title: "Показать котиков",
            style: .plain,
            target: self,
            action: #selector(loadCat)
        )
        
        navigationItem.rightBarButtonItem = testButton
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 120, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = layout

        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
    var index = 0;
    @objc private func loadCat() {
        let urls = [
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgs0LGf5ACsvdG8Ba3-3cs9XV9AeZYb5J5uQzXccdOassAkAgNNBRqCAZF_wo&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxLXa_emhOyrYKxFwi1NB8YqU78ABl3gMyzqhtRYOJIR-h1v3D0wR4yx7UY_w&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsI6fkOvpZm8Yr8A1LyS0-iarGu_9Y4KeTTG0PO4MhsDhU-rqIbnp78kkg9RU&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlpP-akIMFBO-TcIfisUvL5fv1HCGMnm1h1iyt94S_VSQq4WNGeHABUUwh8Q&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4RdMZ30m1kxeGbYUXXYLWHNtVSV5UG3_tYRHl1_SPyr1P4xhMeO9yW7US8A&s"
        ]
        
        guard let nextUrl = URL(string: urls[index]) else { return }
        index=(index+1)%5;
        downloadImage(from: nextUrl) { [weak self] image in
            guard let self = self, let image = image else {return}
            DispatchQueue.main.async {
                self.addImage(image)
            }
        }
    }
    
    private func addImage(_ image: UIImage) {
        images.append(image)
        collectionView.reloadData()
    }
}

extension CatsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // Очищаем старое изображение
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Добавляем новое изображение
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = images[indexPath.item]
        imageView.layer.cornerRadius = 8
        
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.item]
        
        // просмотр с масштабированием
        let сatViewController = CatViewController()
        сatViewController.image = image
        navigationController?.pushViewController(сatViewController, animated: true)
    }
}
