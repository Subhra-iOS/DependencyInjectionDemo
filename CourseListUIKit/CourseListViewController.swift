//
//  CourseListViewController.swift
//  CourseListUIKit
//
//  Created by Subhra Roy on 15/01/22.
//

import Foundation
import UIKit
import APIKit

public class CourseListViewController: UITableViewController{
    
    private var apiHandler: APIRouterProtocol?
    private var courses: [Courses] = []
    
    public init(apiHandler: APIRouterProtocol?) {
        self.apiHandler = apiHandler
        super.init(nibName: nil, bundle: nil)
        self.fetchData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchData(){
        guard let apiBucketHandler = self.apiHandler else { return }
        apiBucketHandler.fetch{ (result: Swift.Result<[Courses], ServiceError>) in
            switch result{
                case .success(let data):
                    self.courses = data
                    DispatchQueue.main.async { [weak self]  in
                        self?.tableView.reloadData()
                    }
                case .failure(let error): print("\(error.localizedDescription)")
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
}

extension CourseListViewController{
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count > 0 ? self.courses.count : 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if self.courses.count > 0{
            let model: Courses = self.courses[indexPath.row]
            cell.textLabel?.text = model.name
        }
        return cell
    }
    
}
