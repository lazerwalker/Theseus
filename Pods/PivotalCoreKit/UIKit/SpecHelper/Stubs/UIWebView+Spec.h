#import <UIKit/UIKit.h>

typedef NSString *(^UIWebViewJavaScriptReturnBlock)();

@interface UIWebView (Spec)

// Loaded Requests
- (NSString *)loadedHTMLString;
- (NSURL *)loadedBaseURL;

// Faking Requests
- (void)sendClickRequest:(NSURLRequest *)request;
- (void)finishLoad;

// Faking Back/Forward Enabled/Disabled state
- (void)setCanGoBack:(BOOL)canGoBack;
- (void)setCanGoForward:(BOOL)canGoForward;

// JavaScript
- (void)setReturnValue:(NSString *)returnValue forJavaScript:(NSString *)javaScript;
- (void)setReturnBlock:(UIWebViewJavaScriptReturnBlock)block forJavaScript:(NSString *)javaScript;
- (NSArray *)executedJavaScripts;

// Debugging
- (void)enableLogging;
- (void)disableLogging;

@end
