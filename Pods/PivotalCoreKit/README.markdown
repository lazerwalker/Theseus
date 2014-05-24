# PivotalCoreKit — Common library code for iOS projects.

[![Build Status](https://travis-ci.org/pivotal/PivotalCoreKit.png?branch=master)](https://travis-ci.org/pivotal/PivotalCoreKit)

## Why PivotalCoreKit
PivotalCoreKit lets you keep creating beautiful apps without having to rewrite the same boilerplate code in every project.

While it has useful functionality in a few different domains, it has a particular focus on helping developers test drive their iOS applications.

## What can PivotalCoreKit help with

### Highlights
* Method swizzling
* Collect/map an NSArray
* Resize a UIImage with aspect fit or aspect fill
* Simulate taps on UIButtons
* Simulate UIGestureRecognizer recognition
* Compare two UIImages for equality
* Query and inspect current UIActionSheet and UIAlertView
* Stub out NSOperationQueue and run its operations on demand
* Stub out NSURLConnection to simulate network activity and callbacks
* Stub out UIWebView's functionality

### Full list
PivotalCoreKit is split along framework lines, with separate Xcode projects for the Foundation, UIKit, and CoreLocation frameworks. Each project is then separated again out into sub-sections: Core, SpecHelper, and SpecHelperStubs. 

**Core** methods are meant to be used anywhere they're useful, whether in specs or in the primary application.  
**SpecHelper** extends built-in classes to make testing easier and more seemless.  
**SpecHelperStubs** stub out (and replace) a class's functionality to allow a developer to more easily inspect its state.

Here is a (hopefully exhaustive but inevitably out of date) list of PivotalCoreKit functionality, separated by framework/section:

* Foundation
  * Core
    * Convert NSString into a SHA1 hash (as NSData)
    * Convert NSData into a hexadecimal string
    * Method redirection on NSObjects (also commonly called Swizzling)
    * Convert an NSString ("Hello world I am doing great today") into camel case ("HelloWorldIAmDoingGreatToday")
    * Check if an NSString is blank
    * Check if an NSString is a valid email address
    * Percent escape encode an NSString including characters the build-in percent escaping doesn't include.
    * Map an NSArray into another NSArray by collecting items through a block
    * Convert an NSDictionary into a string of query parameters
    * NSURLConnectionDelegate based networking service (PCKHTTPConnection and PCKHTTPInterface)
    * An event-driven XML parser (PCKParser)
  * SpecHelper
    * Break out query parameters of an NSURL into an NSDictionary
    * Fake out NSURLConnection to keep it from actually accessing network and fire success/failure responses on demand
    * Return the body of an NSURLRequest as a string
    * Fake out +[NSUUID UUID] to return consistent results
    * Fake out NSOperationQueue to execute blocks on demand
* UIKit
  * Core
    * Produce a UIBarButtonItem from a UIButton
    * Resize a UIImage with aspect fill or aspect fit
    * Crop a UIImage or add rounded corners
    * Translating UIViews by deltas
    * Resizing UIViews with corner pinning
    * Calculate accurate height from NSString and NSAttributedString drawing
  * SpecHelper
    * Simulate a tap on 
      * UIButton
      * UITableViewCell
      * UICollectionViewCell
      * UIBarButtonItem
      * UITabBarController item
    * Simulate a tap, swipe, or pinch on a UIView (triggers attached gesture recognizers)
    * Simulate a new value for a UISlider
    * Simulate recognition of specific gesture recognizer
    * Compare UIImages for equality 
    * Query a UIWindow for the first responder
  * SpecHelperStubs
    * Query, inspect, and simulate taps on the current UIActionSheet
    * Query, inspect, and simulate taps on the current UIAlertView
    * Simulate availability states of UIImagePickerController (camera available/not available, et cetera)
    * Inspect arguments (duration, delay, options) on last UIView animation
    * Fake out UIWebView to inspect requests, simulate back/forward state, and simulate web loads
* CoreLocation
  * SpecHelper
    * Simulate Geocoding success or failure

PivotalCoreKit is test-driven and includes Specs in each project.

## That sounds great, give me some examples

Maybe you have a bunch of quarterly reports and want to collect all the finances from the first week for each report.  
After linking to **Foundation+PivotalCore**
```objc
#import "NSArray+PivotalCore.h"
/* ... */
Week week = FirstWeek;
NSArray *firstWeekFinances = [reports collect:^id(PLReport *report) {
    return [report financesForWeek:week];
}];
```

Or maybe you're testing that tapping a button properly fires off a network request  
After linking to **UIKit+PivotalSpecHelper**  
```objc
#import "UIControl+Spec.h"
/* ... */
describe(@"when the button is tapped", ^{
    beforeEach(^{
        [button tap];
    });

    it(@"fires a network request", ^{
        apiClient should have_received(@selector(requestNewestRecipes));
    });
});
```

Say you want to check what URL a webview was asked to load.
After linking to **UIKit+PivotalSpecHelperStubs**
```objc
#import "UIWebView+Spec.h"
/* ... */
it(@"webview should load example.com", ^{
    controller.webView.request.URL.absoluteString should equal(@"http://example.com");
});
```
Without PivotalCoreKit's UIWebView stubs, the webView's NSURLRequest will be nil because the real UIWebView hasn't started actually making the request. A stubbed UIWebView updates the request property immediately.

## How do I install PivotalCoreKit
* In a shell in the root of your project run: `git submodule add git@github.com:pivotal/PivotalCoreKit.git Externals/PivotalCoreKit`
* Add the PivotalCoreKit project(s) (Foundation.xcodeproj, UIKit.xcodeproj, or CoreLocation.xcodeproj) you need into your project for the appropriate target
* In your application's Project Settings, under Build Phases, add the desired StaticLib to "Target Dependencies"
* Add the corresponding binary to the Link Binary With Libraries section
* Switch to Build Settings and update your Header Search Paths to include the path to folder containing the added subproject. Make it recursive.
 * e.g. "$(SRCROOT)/Externals/PivotalCoreKit/path/to/specific/projectfolder/". 

### Example, adding -[UIButton tap] to a spec target
* `git submodule add git@github.com:pivotal/PivotalCoreKit.git Externals/PivotalCoreKit`
* Right-click Specs folder in Xcode -> Add Files
* Navigate into PivotalCoreKit/UIKit folder, select UIKit.xcodeproj and add.
* In root project file, choose Specs target
* Under the "Build Phases" tab along the top of the project settings, add UIKit+PivotalSpecHelper-StaticLib to "Target Dependencies"
* Add libUIKit+PivotalSpecHelper-StaticLib.a to the "Link Binary With Library" section
* Switch to the "Build Settings" tab Add "$(SRCROOT)/Externals/PivotalCoreKit/UIKit/" to "Header Search Paths" and make it recursive
* In the desired spec file, add #import "UIControl+Spec.h" and freely use [button tap];

## Library Documentation

Documentation for specific methods and functionality can be found at http://cocoadocs.org/docsets/PivotalCoreKit/
			
## MIT License

Copyright (c) 2014 Pivotal Labs (http://pivotallabs.com/)  
Contact email: akitchen@pivotallabs.com

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
