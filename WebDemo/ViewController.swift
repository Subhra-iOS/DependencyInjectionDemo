//
//  ViewController.swift
//  WebDemo
//
//  Created by Subhra Roy on 09/12/21.
//

import UIKit
import DesignWebTool
import ServerErrorLog

import CocoaLumberjackSwift
//import CocoaLumberjackSwiftLogBackend
//import Logging
import APIKit
import CourseListUIKit

struct NavigationColor {
    static let navColor : UIColor = UIColor(red: (255.0/255.0), green: (23.0/255.0), blue: (77.0/255.0), alpha: 1.0)
}

private enum Constant{
    enum Handler{
        static let  preview = "previewHandler"
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Home"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    
    @IBAction func didTapOnWebTool(_ sender: Any) {
        self.openDesignTool()
    }
    

    private func openDesignTool(){
        let shareDesignTool = SharedDesignToolController(
                                model: WebToolModel(url: URL(string: "https://en.wikipedia.org/wiki/Code_coverage")!,
                                method: "get",
                                uiModel: UIModel(navBarColor: UIColor.systemBackground,
                                                 navBarTextColor: UIColor.white,
                                                 dismissBtnText: "Back",
                                                 navBarTitle: "Design Tool"),
                                selector: Constant.Handler.preview),
                                delegate: self
        )
        
        self.navigationController?.pushViewController(shareDesignTool, animated: true)
    }
    
    private func generateErrorLibrary(){
        let errorLog: ServerErrorLog = ServerErrorLog(url: URL(string: "")!, header: [:], payload: ServicePayload(response: HTTPURLResponse(), data: Data(), error: nil, method: "POST"))
        
        errorLog.sendErrorLog()
    }
    
    private func generate3rdPartyLogger(){
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 5
        fileLogger.maximumFileSize = (1024*1024*1); //1MB
        DDLog.add(fileLogger)
        
        DDLogVerbose("Verbose")
        DDLogDebug("Debug")
        DDLogInfo("Info")
        DDLogWarn("Warn")
        DDLogError("Error")
    }
    
    @IBAction func didTapOnList(_ sender: Any) {
        let apiBucket: APIBucket = APIBucket(url: "https://iosacademy.io/api/v1/courses/index.php")
        let courseListVC: CourseListViewController = CourseListViewController(apiHandler: apiBucket)
        present(courseListVC, animated: true, completion: nil)
    }
    
}

extension ViewController: NavigationProtocol{
    func popViewController(on: Status, data: Data?) {
        
    }
    
    func didBackNavigation() {
        print("Back here")
    }
    
}


