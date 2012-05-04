#import "SMStubView.h"

@implementation SMStubView

@synthesize delegate = _delegate;

- (void)dealloc {
	[_leftView release];
	[_rightView release];
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
		_leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left.png"]];
		_leftView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, _leftView.frame.size.width, _leftView.frame.size.height);
		[self addSubview:_leftView];
		_leftView.hidden = YES;
		_rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];
		_rightView.frame = CGRectMake(self.bounds.size.width-(_rightView.frame.size.width), self.bounds.origin.y, _leftView.frame.size.width, _leftView.frame.size.height);
		[self addSubview:_rightView];
		
		_isUsingScrollView = YES;
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
	[_menus release];
	_menus = [menus copy];
	CGFloat contentOffset = 0;
	for (NSUInteger i=0; i<_menus.count; i++) {
		NSString *menu = [_menus objectAtIndex:i];
		CGRect labelFrame = CGRectMake(contentOffset, 0, 160, self.bounds.size.height);
		UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:16];
		label.text = menu;
		[_scrollView addSubview:label];
		[label release];
		contentOffset += 160;
		_scrollView.contentSize = CGSizeMake(160*(i+1), 23);
	}
}

- (void)scrollToIndex:(int)index {
	CGRect frame;
	frame.origin.x = _scrollView.frame.size.width * index;
	frame.origin.y = 0;
	frame.size = _scrollView.frame.size;
	[_scrollView scrollRectToVisible:frame animated:YES];
	_isUsingScrollView = NO;
	[_scrollView scrollRectToVisible:frame animated:YES];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	_isUsingScrollView = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	_isUsingScrollView = YES;
	CGFloat pageWidth = _scrollView.frame.size.width;
	int index = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if ([_delegate respondsToSelector:@selector(stubViewDidEndDeceleratingToIndex:)]) {
		[_delegate stubViewDidEndDeceleratingToIndex:index];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat pageWidth = _scrollView.frame.size.width;
	int index = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if (index <= 0) _leftView.hidden = YES;
	else _leftView.hidden = NO;
	if (index >= (_menus.count-1)) _rightView.hidden = YES;
	else _rightView.hidden = NO;
}

@end
