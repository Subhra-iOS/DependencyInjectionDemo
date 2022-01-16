//
//  CourseListUIKitTests.swift
//  CourseListUIKitTests
//
//  Created by Subhra Roy on 15/01/22.
//

import XCTest
@testable import CourseListUIKit
//@testable import APIKit


class CourseListUIKitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadViewWithAllFeeds() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let courses: [Courses] = [
            Courses(name: "Course1", image: "Course1 image url"),
            Courses(name: "Course2", image: "Course2 image url"),
            Courses(name: "Course3", image: "Course3 image url")
        ]
        
        let service: FeedServiceManagerStub = FeedServiceManagerStub(courses: [
            .success(courses)
        ])
        let listVC: CourseListViewStubController = CourseListViewStubController(apiHandler: service)
        listVC.simulateViewWillAppear()
        XCTAssertEqual(listVC.feedList.count,3)
    }
    
    func testLoadViewWithTwoRetryAndSuccess() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let courses: [Courses] = [
            Courses(name: "Course1", image: "Course1 image url"),
            Courses(name: "Course2", image: "Course2 image url"),
            Courses(name: "Course3", image: "Course3 image url")
        ]
        
        let service: FeedServiceManagerStub = FeedServiceManagerStub(courses: [
            .failure(ServiceError.invalid),
            .failure(ServiceError.nodata),
            .success(courses)
        ])
        let listVC: CourseListViewStubController = CourseListViewStubController(apiHandler: service)
        listVC.simulateViewWillAppear()
        XCTAssertEqual(listVC.feedList.count,3)
    }
    
    func testLoadViewWithAllRetryButFails() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let service: FeedServiceManagerStub = FeedServiceManagerStub(courses: [
            .failure(ServiceError.invalid),
            .failure(ServiceError.nodata),
            .failure(ServiceError.parseError)
        ])
        let listVC: CourseListViewStubController = CourseListViewStubController(apiHandler: service)
        listVC.simulateViewWillAppear()
        XCTAssertEqual(listVC.errorMessage,"invalid")
    }
    
    func testLoadViewWithOneRetryAndSuccess() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let courses: [Courses] = [
            Courses(name: "Course1", image: "Course1 image url"),
            Courses(name: "Course2", image: "Course2 image url"),
            Courses(name: "Course3", image: "Course3 image url")
        ]
        
        let service: FeedServiceManagerStub = FeedServiceManagerStub(courses: [
            .failure(ServiceError.invalid),
            .success(courses)
        ])
        let listVC: CourseListViewStubController = CourseListViewStubController(apiHandler: service)
        listVC.simulateViewWillAppear()
        XCTAssertEqual(listVC.feedList.count,3)
    }
    
}

private class CourseListViewStubController: CourseListViewController{
        
    func simulateViewWillAppear(){
        loadViewIfNeeded()
        beginAppearanceTransition(true, animated: false)
    }
    
    var feedList: [Courses]!
    private var serviceManager: FeedServiceManagerStub
    var errorMessage: String = ""
    init(apiHandler: FeedServiceManagerStub) {
        self.serviceManager = apiHandler
        super.init(apiHandler: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData(retry: 3)
    }
    
    private func loadData(retry count: Int = 0){
        self.serviceManager.fetch { (result: Swift.Result<[Courses], ServiceError>) in
            switch result{
                case .success(let list): self.feedList = list
                case .failure(let error):
                    print("\(error.localizedDescription)")
                    switch count {
                        case let retry where retry == 1:
                            print("Error after all retry")
                            self.errorMessage = "invalid"
                        default:
                            self.loadData(retry: count - 1)
                    }
            }
        }
    }
    
}

private class FeedServiceManagerStub: APIRouterStubProtocol{
   
    private var courses: [Swift.Result<[Courses], ServiceError>]
    
    init(courses: [Swift.Result<[Courses], ServiceError>]) {
        self.courses = courses
    }
    
    func fetch(completion: @escaping (Result<[Courses], ServiceError>) -> ())  {
        if courses.count > 0{
            completion(self.courses.removeFirst())
        }
    }
    
}

private protocol APIRouterStubProtocol{
    func fetch(completion: @escaping (Swift.Result<[Courses], ServiceError>) -> ())
}

private struct CourseStub: CourseProperties {
    var name: String
    var image: String
}
