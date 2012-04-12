#import <UIKit/UIKit.h>

@class SMStubViewViewController;

@interface SMStubViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SMStubViewViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SMStubViewViewController *viewController;

@end

