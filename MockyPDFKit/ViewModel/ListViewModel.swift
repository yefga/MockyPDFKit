//
//  ListViewModel.swift
//  MockyPDFKit
//
//  Created by Yefga on 31/07/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import UIKit

final class ListViewModel {
    
    var items: [Item] = []
        
    func fetch(onLoading: @escaping voidHandler, onSuccess: @escaping voidHandler) {
        let manager = API(session: .shared)
        
        onLoading()
        
        manager.request { (result) in
            switch result {
            case .success(let data):
                if let mocky = try? JSONDecoder().decode(Mocky.self, from: data) {
                    self.items = mocky.data
                    onSuccess()
                }
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
}


extension ListViewModel {
    
    var numberOfRowsInSection: Int {
        return items.count
    }
    
    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return .init() }
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }

}
