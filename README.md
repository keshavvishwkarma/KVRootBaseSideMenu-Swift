# KVRootBaseSideMenu-Swift

It's a root base side menu with autolayout for iOS applications & It is also written in pure swift.
### Demo
[![KVRootBaseSideMenu-Swift](http://img.youtube.com/vi/104QJ6Nn77A/0.jpg)](http://www.youtube.com/watch?v=104QJ6Nn77A)

###Features
- [x] Highly customizable & easy to use.
- [x] You can add this side menu in a view of viewCintroller Or any specific subview of viewcontroller.
- [x] Support both left & right side menu.
- [x] Support finger touch to open or close both side menu
- [x] Automatic orientation support because of autolayout that we used.
- [x] Automatically manage Left, right or left & right side menu sliding & toggle functionality to open or close.
- [x] Complete example

###TO DO
- [ ] By supporting @IBInspectable, the class properties can be exposed in the Interface Builder
- [ ] Carthage Support
- [ ] Advance example.

### Requirements
* iOS 8+ (compatible with iOS 8)
* Xcode 7.2

<a name="usage"> Usage </a>
--------------
####`Step 1.`
Prepare `SideMenuViewController`,  either `LeftViewController` or `RightViewController` or both.
- Create a subclass of **KVRootBaseSideMenuViewController** called SideMenuViewController.
- Create LeftViewController Or RightViewController Or both class subclassing from UIViewController.
```
class SideMenuViewController: KVRootBaseSideMenuViewController {

}
class LeftViewController: UIViewController {

}
class RightViewController: UIViewController {

}
```
- In Storyboard, Drag three view controllers from the Object library to the storyboard canvas and give them class  name in the Attributes inspector for the scenes. one is  `SideMenuViewController ` second is `LeftViewController` & third is `RightViewController`.

####`Step 2.`
- Prepare roots(options available in left and/or Right side menu) & roots identifiers and [Connect](#Connect_Roots) all the roots from side menu view controller.

- In storyboard, drag view controller objects from the Object library to the scene, create a custom view controller class. Specify this class as the custom class in the Attributes inspector for the scene.

- Now define the roots Identifier, in this example I'm doing as -
```
public extension KVSideMenu
{
    // Here define the roots identifier of side menus that must be connected
    // from KVRootBaseSideMenuViewController or any derived class of it
    // In Storyboard using KVCustomSegue
    
    static public let leftSideViewController   =  "LeftSideViewController"
    static public let rightSideViewController  =  "RightSideViewController"
    
    struct RootsIdentifiers
    {
        static public let initialViewController  =  "SecondViewController"

        // All roots viewcontrollers
        static public let firstViewController    =  "FirstViewController"
        static public let secondViewController   =  "SecondViewController"
    }
    
}
```

<a name="Connect_Roots"> How to connect roots from side menu view controller </a>
-----
- You need to create a segue from the `SideMenuViewController` itself to the destination root viewController. You must do this for each root viewController and give them appropriate `identifiers` and give them ’Segue Class’ i.e. `KVCustomSegue`

####`Step 3.`

- To enable left or right or both SideMenu, you must assign a `leftSideMenuViewController` or `rightSideMenuViewController` or both at any moment. In this example I'm doing as -
```
class SideMenuViewController: KVRootBaseSideMenuViewController
{
    override func viewDidLoad() {
      super.viewDidLoad()
        
      // Configure The Side Menu
      leftSideMenuViewController  =  self.storyboard?.instantiateViewControllerWithIdentifier(KVSideMenu.leftSideViewController)
      rightSideMenuViewController =  self.storyboard?.instantiateViewControllerWithIdentifier(KVSideMenu.rightSideViewController)

      // Set default root
      self.performSegueWithIdentifier(KVSideMenu.RootsIdentifiers.initialViewController, sender: self)
    }

}
```
Now side menu setup is done.

#### To Change Root call -
`public func changeSideMenuViewControllerRoot(rootIdentifier:String) `

#### To Toggle Side Menu Post notification
`Post notification by name KVSideMenu.Notifications.toggleRight Or KVSideMenu.Notifications.toggleLeft `

Ex- 

```
class LeftSideViewController: UIViewController
{
    @IBAction func moveToFirstViewControllerButton(sender: AnyObject) {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.firstViewController)
        NSNotificationCenter.defaultCenter().postNotificationName(KVSideMenu.Notifications.toggleLeft, object: self)
    }
    
    @IBAction func moveToSecondViewControllerButton(sender: AnyObject) {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.secondViewController)
        NSNotificationCenter.defaultCenter().postNotificationName(KVSideMenu.Notifications.toggleLeft, object: self)
    }

}

class RightSideViewController: UIViewController 
{
    @IBAction func moveToFirstViewControllerButton(sender: AnyObject) {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.firstViewController)
        NSNotificationCenter.defaultCenter().postNotificationName(KVSideMenu.Notifications.toggleRight, object: nil)
    }
    
    @IBAction func moveToSecondViewControllerButton(sender: AnyObject) {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.secondViewController)
        NSNotificationCenter.defaultCenter().postNotificationName(KVSideMenu.Notifications.toggleRight, object: nil)
    }

}

```
## Author
Keshav Vishwkarma, keshavvbe@gmail.com

## License

KVRootBaseSideMenu-Swift is released under the MIT license. See the LICENSE for details.
