#import <UIKit/UIKit.h>
#import "SMStubView.h"

@interface SMStubViewController : UIViewController <SMStubViewDelegate> {
	SMStubView *	_stubView;
	UILabel *		_label;
}

@end

