#import <UIKit/UIKit.h>

@class SMStubViewController;

@interface SMStubViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SMStubViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SMStubViewController *viewController;

@end

