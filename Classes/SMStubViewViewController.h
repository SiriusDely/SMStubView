#import <UIKit/UIKit.h>
#import "SMStubView.h"

@interface SMStubViewViewController : UIViewController <SMStubViewDelegate> {
	SMStubView *	_stubView;
	UILabel *		_label;
}

@end

