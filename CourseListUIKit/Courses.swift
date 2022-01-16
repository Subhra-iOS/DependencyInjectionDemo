//
//  Courses.swift
//  CourseListUIKit
//
//  Created by Subhra Roy on 15/01/22.
//

import Foundation

protocol CourseProperties {
    var name: String { get set }
    var image: String { get set }
}

struct Courses: Decodable, CourseProperties {
     var name: String
     var image: String
}

extension Courses: CustomStringConvertible{
    public var description: String{
        return "This is \(self.name) ->>> \(self.image) model"
    }
}
