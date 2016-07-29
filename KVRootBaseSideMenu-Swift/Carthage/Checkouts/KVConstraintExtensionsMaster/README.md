# KVConstraintExtensionsMaster

## -----: Go Easy On Programatically Constraints :----
### ``` + Points ```

 - [x] No need to use more ``` IBOutlet reference ``` of the constraint instead of this you can directy access already applied constraint (means expected constraint) either applied ``` Programatically ``` or ``` Interface Builder ```on any view.

 - [x] You can easily add those constraints that are not ``` possible or very difficult from StoryBoard/xib```.

 - [x] Since Constraints are ``` cumulative ``` & do not override to each other. if you have an existing constraint, setting another constraint of the same type does not override the previous one. So ``` This library add any constraint only once ``` so you don't need to worry about what happened if we ``` add same ``` constraint many time.
 - [x] Easily ``` modify ``` any constraint and ``` replace ``` it with new constraint too.
 
 - [x] Easily ``` modify ``` any constraint with nice animation.
 
 - [x] you can easily ``` add Proportion/Ratio ``` constraints too in iOS 7,8,9 and later.
 
 - [x] you can ``` add multiple ``` constraints by writing few lines of code.

 - [x] All the methods of this library have prefixes ``` prepare ```or``` apply ``` according their behaviour. so you don't need to remember all methods just type method prefixes then ``` compiler automatically``` gives you ``` suggestions ``` for methods.

 A method which has prefixe ``` prepare ``` - is used to either prepare the constraint or prepare the view for the constraint.
 A method which has prefixe ``` apply ``` - is used to apply\add the constraint into its appropriate view.

``` Usage ```
-----

- drag the KVConstraintExtensionsMaster folder into your project.
- import the KVConstraintExtensionsMaster.h file in class
```objective-c
#import "KVConstraintExtensionsMaster.h"
```

``` 
##  ------: Just Two steps to Apply\Add constraints by programatically :------
```
  ``` Step 1 ``` Create & configure the view hierarchy for constraint first.
   
  ``` Step 2 ``` Apply the constraints by calling KVConstraintExtensionsMaster library methods which have prefix
                 ``` apply ``` according to constraints by selected view.
  
```
@interface ViewController ()
  
@property (strong, nonatomic) UIView *containerView;// may be any view like /*containerView*/

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self createAndConfigureViewHierarchy]; // Step 1
    [self applyConstaint];   // Step 2
}

- (void)createAndConfigureViewHierarchy
{
    self.containerView = [UIView prepareNewViewForAutoLayout];
    self.containerView.backgroundColor = [UIColor Purple];
    [self.view addSubview:self.containerView];
}

-(void)applyConstaint
{
    // Here we are going to apply constraints
    [self.containerView applyLeadingPinConstraintToSuperviewWithPadding:20];
    [self.containerView applyTrailingPinConstraintToSuperviewWithPadding:20];
    
    //  we can also apply leading and trailing of containerView both by using the below method. 
        But this method is only useful when both leading and trailing have same pading.
    // [self.containerView applyLeadingAndTrailingPinConstraintToSuperviewWithPadding:0];

    [self.containerView applyTopPinConstraintToSuperviewWithPadding:65.0f];
    [self.containerView applyBottomPinConstraintToSuperviewWithPadding:50.0f];
}

@end

```

License
-----

KVConstraintExtensionsMaster is released under the MIT license.