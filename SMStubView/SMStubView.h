
#import <UIKit/UIKit.h>

@protocol SMStubViewDelegate <NSObject>
@optional
- (void)viewStubDidEndDeceleratingToIndex:(int)index;
@end

@interface SMStubView : UIView <UIScrollViewDelegate> {
	UIScrollView *			_scrollView;
	id <SMStubViewDelegate>	_delegate;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id <SMStubViewDelegate> delegate; 

@end
