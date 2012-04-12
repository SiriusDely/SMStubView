#import "SMStubView.h"

@implementation SMStubView

@synthesize scrollView = _scrollView;
@synthesize delegate = _delegate;

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview.png"]];
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.center.x-(self.bounds.size.width/2/2), self.bounds.origin.y, (self.bounds.size.width/2), self.bounds.size.height)];
		_scrollView.delegate = self;
		_scrollView.clipsToBounds = NO;
		_scrollView.pagingEnabled = YES;
		_scrollView.showsHorizontalScrollIndicator = NO;
		[self addSubview:_scrollView];
	}
	return self;
}

- (void)dealloc {
	[_scrollView release];
    [super dealloc];
}

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
