#import <UIKit/UIKit.h>
#import "SMStubView.h"

@interface SMStubViewViewController : UIViewController <SMStubViewDelegate> {
	SMStubView *	_viewStub;
	UILabel *		_label;
}

@end

