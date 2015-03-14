//
//  ContainerViewController.swift
//  EasternPioneerBusSwift
//
//  Created by hqlgree2 on 14/3/15.
//  Copyright (c) 2015 hqlgree2. All rights reserved.
//

import UIKit
import Realm
import Alamofire

enum SlideOutState{
    case BothCollapsed
    case BusLineExpanded
    case SettingExpanded
}

class ContainerViewController: UIViewController,
    BusStopDelegate, UIGestureRecognizerDelegate{
    
    var currentState: SlideOutState = .BothCollapsed{
        didSet{
            let showShadow = currentState != .BothCollapsed
            showShadowForBusStopController(showShadow)
        }
    }
    
    // show shadow
    func showShadowForBusStopController(shouldShowShadow: Bool){
        if shouldShowShadow{
            navigation.view.layer.shadowOpacity = 0.8
        }
        else{
            navigation.view.layer.shadowOpacity = 0.0
        }
    }
    
    var navigation: UINavigationController!
    var busLineController: BusLineViewController?
    var busStopController: BusStopViewController!
    var settingController: SettingViewController?
    
    let expandedOffset: CGFloat = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = RLMRealm.defaultRealm()
        println(realm.path)
//        Alamofire.request(.GET, "http://wsyc.dfss.com.cn/home/BCView")
//            .responseString{ (_,_, string, _ ) in
//                let parser = Parser(html:string!)
//                parser.parse()
//        }

        // Do any additional setup after loading the view.
        busStopController = UIStoryboard.busStopController()
        busStopController.delegate = self
        
        navigation = UINavigationController(rootViewController: busStopController)
        view.addSubview(navigation.view)
        addChildViewController(navigation)
        navigation.didMoveToParentViewController(self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        navigation.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (0 < recognizer.velocityInView(view).x)
        
        switch(recognizer.state){
        case .Began:
            if .BothCollapsed == currentState{
                if gestureIsDraggingFromLeftToRight{
                    addBusLineControllerPanel()
                }
                else{
                    addSettingControllerPanel()
                }
                showShadowForBusStopController(true)
            }
        case .Changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            recognizer.setTranslation(CGPointZero, inView: view)
        case .Ended:
            if nil != busLineController{
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateBusLinePanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            else if nil != settingController{
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x < 0
                animateSettingPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
    
    //
    func toggleBusLine() {
        let notAlreadyExpanded = (currentState != .BusLineExpanded)
        if notAlreadyExpanded{
            addBusLineControllerPanel()
        }
        
        animateBusLinePanel(shouldExpand: notAlreadyExpanded)
    }
    
    //
    func addBusLineControllerPanel(){
        if nil == busLineController{
            busLineController = UIStoryboard.busLineController()!
            addBusLineController(busLineController!)
        }
    }
    
    //
    func addBusLineController(busLineController: BusLineViewController){
        busLineController.delegate = busStopController
        
        view.insertSubview(busLineController.view!, atIndex: 0)
        addChildViewController(busLineController)
        busLineController.didMoveToParentViewController(self)
    }
    
    //
    func animateBusLinePanel(#shouldExpand: Bool){
        if shouldExpand{
            currentState = .BusLineExpanded
            animatePanelXPosition(targetPosition: CGRectGetWidth(navigation.view.frame) - expandedOffset)
        }
        else{
            animatePanelXPosition(targetPosition: 0, completion: { finished in
                self.currentState = .BothCollapsed
                self.busLineController!.view.removeFromSuperview()
                self.busLineController = nil
            })
        }
    }
    
    //
    func animatePanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil){
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .CurveEaseInOut,
            animations: {
                self.navigation.view.frame.origin.x = targetPosition
            },
            completion: completion)
    }
    
    //
    func toggleSetting() {
        let notAlreadyExpanded = (currentState != .SettingExpanded)
        if notAlreadyExpanded{
            addSettingControllerPanel()
        }
        
        animateSettingPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addSettingControllerPanel(){
        if nil == settingController{
            settingController = UIStoryboard.settingController()
            
            addSettingController(settingController!)
        }
    }
    
    func addSettingController(settingController: SettingViewController){
        settingController.delegate = busStopController
        view.insertSubview(settingController.view, atIndex: 0)
        addChildViewController(settingController)
        settingController.didMoveToParentViewController(self)
    }
    
    func animateSettingPanel(#shouldExpand: Bool){
        if shouldExpand{
            currentState = .SettingExpanded
            animatePanelXPosition(targetPosition: -CGRectGetWidth(navigation.view.frame) + expandedOffset)
        }
        else{
            animatePanelXPosition(targetPosition: 0, completion: { _ in
                self.currentState = .BothCollapsed
                self.settingController!.view.removeFromSuperview()
                self.settingController = nil
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

private extension UIStoryboard{

    class func mainStoryboard() -> UIStoryboard{
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
    class func busLineController() -> BusLineViewController?{
        return mainStoryboard().instantiateViewControllerWithIdentifier("BusLineViewController") as? BusLineViewController
    }
    
    class func busStopController() -> BusStopViewController?{
        return mainStoryboard().instantiateViewControllerWithIdentifier("BusStopViewController") as? BusStopViewController
    }
    
    class func settingController() -> SettingViewController?{
        return mainStoryboard().instantiateViewControllerWithIdentifier("SettingViewController") as? SettingViewController
    }
}
