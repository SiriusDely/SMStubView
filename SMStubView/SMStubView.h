
#import <UIKit/UIKit.h>

@protocol SMStubViewDelegate <NSObject>
@optional
- (void)stubViewDidEndDeceleratingToIndex:(int)index;
@end

@interface SMStubView : UIView <UIScrollViewDelegate> {
	UIScrollView *			_scrollView;
	id <SMStubViewDelegate>	_delegate;
	NSArray *				_menus;
	UIImageView *			_leftView;
	UIImageView *			_rightView;
	BOOL					_isUsingScrollView;
}

@property (nonatomic, assign)	id <SMStubViewDelegate> delegate;

- (void)setMenus:(NSArray *)menus;
- (void)scrollToIndex:(int)index;

@end
