#import "SMStubView.h"

@implementation SMStubView

@synthesize scrollView = _scrollView;
@synthesize delegate = _delegate;

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.center.x-(self.bounds.size.width/2/2), self.bounds.origin.y, (self.bounds.size.width/2), self.bounds.size.height)];
		_scrollView.delegate = self;
		[self addSubview:_scrollView];
		NSLog(@"SMViewStub init.");
	}
	return self;
}

#pragma mark -
#pragma mark Construction & Destruction

- (void)dealloc {
	[_scrollView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIView methods

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self pointInside:point withEvent:event]) {
		return _scrollView;
	}
	return nil;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat pageWidth = _scrollView.frame.size.width;
	int index = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if ([_delegate respondsToSelector:@selector(viewStubDidEndDeceleratingToIndex:)]) {
		[_delegate viewStubDidEndDeceleratingToIndex:index];
	}
}

@end
