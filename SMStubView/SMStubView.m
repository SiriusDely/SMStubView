#import "SMStubView.h"

@implementation SMStubView

@synthesize scrollView = _scrollView;
@synthesize delegate = _delegate;

- (void)dealloc {
	[_menus release];
	[_scrollView release];
    [super dealloc];
}

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview.png"]];
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.center.x-(self.bounds.size.width/2/2), self.bounds.origin.y, (self.bounds.size.width/2), self.bounds.size.height)];
        _scrollView.delegate = self;
		_scrollView.clipsToBounds = NO;
		_scrollView.pagingEnabled = YES;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height*2);
		[self addSubview:_scrollView];
	}
	return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self pointInside:point withEvent:event]) {
		return _scrollView;
	}
	return nil;
}

- (void)setMenus:(NSArray *)menus {
	NSLog(@"setMenus");
	[_menus release];
	_menus = [menus copy];
	CGFloat contentOffset = 0;
	for (unsigned i=0; i<_menus.count; i++) {
		NSString *menu = [_menus objectAtIndex:i];
		CGRect labelFrame = CGRectMake(contentOffset, 0, 160, 23);
		UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:14];
		label.text = menu;
		[_scrollView addSubview:label];
		[label release];
		contentOffset += 160;
		_scrollView.contentSize = CGSizeMake(160*(i+1), 23);
	}
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat pageWidth = _scrollView.frame.size.width;
	int index = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if ([_delegate respondsToSelector:@selector(stubViewDidEndDeceleratingToIndex:)]) {
		[_delegate stubViewDidEndDeceleratingToIndex:index];
	}
}

- (void)shit {
	NSLog(@"shit");
}

@end
