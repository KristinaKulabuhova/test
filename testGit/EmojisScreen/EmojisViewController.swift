//
//  EmojisViewController.swift
//  testGit
//
//  Created by Kristina on 05.07.2022.
//

import UIKit

final class EmojisViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var emojis: Array<Any> = []
    var collectionView : UICollectionView?
    let width = UIScreen.main.bounds.width
    
    struct ConstSize {
        let offset: CGFloat = UIScreen.main.bounds.width / 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //layout.estimatedItemSize = CGSize(width: width / 7, height: width / 7)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView?.contentMode = .scaleAspectFill
        tabBarController?.tabBar.isHidden = false
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(IconViewCells.self, forCellWithReuseIdentifier: IconViewCells.identifier)
        if let collection = collectionView {
            view.addSubview(collection)
        }
        getEmoji()

    }
    
    func getEmoji() {
        guard let url = URL(string: "https://api.github.com/emojis") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)

        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        Task {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            do {
               let emojisDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                emojis = Array(emojisDict!.values)
                collectionView?.refreshControl?.endRefreshing()
                collectionView?.reloadData()
            } catch {
               print(error.localizedDescription)
           }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconViewCells.identifier, for: indexPath) as! IconViewCells
        cell.setUpIcon(url: emojis[indexPath.row] as! String)
        return cell
    }
    
}
