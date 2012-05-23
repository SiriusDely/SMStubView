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
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.center.x-(self.bounds.size.width/2/2/2), self.bounds.origin.y, (self.bounds.size.width/2/2), self.bounds.size.height)];
        _scrollView.delegate = self;
		_scrollView.clipsToBounds = NO;
		_scrollView.pagingEnabled = YES;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        _scrollView.canCancelContentTouches = YES;
		//[self addSubview:_scrollView];
        
		_isUsingScrollView = YES;
	}
	return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self pointInside:point withEvent:event]) {
        //NSLog(@"hit");
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
		CGRect labelFrame = CGRectMake(contentOffset, 0, 160/2, self.bounds.size.height);
        CGSize labelsize;
		UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setNumberOfLines:0];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:12];
		label.text = [menu uppercaseString];
        labelsize = [menu sizeWithFont:label.font constrainedToSize:CGSizeMake(80,44) lineBreakMode:UILineBreakModeWordWrap];
        label.frame = CGRectMake(contentOffset+2, 0, 160/2, 44);
        [label setTag:i+1];
        //[label setUserInteractionEnabled:YES];
		[_scrollView addSubview:label];
		
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = label.frame;
        [button addTarget:self action:@selector(labelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTag:i+11];
        [button setUserInteractionEnabled: YES];
        [label addSubview:button];
        
        if (i!=0) {
            UIImageView *border = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x-2, 0, 2, 44)];
            border.image = [UIImage imageNamed:@"line.png"];
            [_scrollView addSubview:border];
            [border release];
        }
        
		contentOffset += 82;
		_scrollView.contentSize = CGSizeMake(82*(i+1), 44);
        [label release];
	}
    [self addSubview:_scrollView];
}

- (void)labelButtonPressed:(id)sender{
    NSLog(@"button pressed");
}

- (int)activeIndex{
    CGFloat pageWidth = _scrollView.frame.size.width;
	int index = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    return index;
}

- (void)scrollToIndex:(int)index {
    NSLog(@"index: %d",index);
	CGRect frame;
	frame.origin.x = 82*index;
	frame.origin.y = 0;
	frame.size = _scrollView.frame.size;
	[_scrollView scrollRectToVisible:frame animated:YES];
	_isUsingScrollView = NO;
	[_scrollView scrollRectToVisible:frame animated:YES];
    
    UILabel *label = [_scrollView viewWithTag:index+1];
    [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview-press.png"]]];
    [label setTextColor:[UIColor colorWithRed:00.0/255.0 green:133.0/255.0 blue:126.0/255.0 alpha:1.0]];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    
    if (index!=0) {
        UILabel *prevLabel = [_scrollView viewWithTag:index];
        [prevLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview.png"]]];
        [prevLabel setTextColor:[UIColor whiteColor]];
        [prevLabel setFont:[UIFont systemFontOfSize:12]];
    }
    
    if (index<_menus.count-1) {
        UILabel *nextLabel = [_scrollView viewWithTag:index+2];
        [nextLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview.png"]]];
        [nextLabel setTextColor:[UIColor whiteColor]];
        [nextLabel setFont:[UIFont systemFontOfSize:12]];
    }
    
    if ([_delegate respondsToSelector:@selector(stubViewDidEndDeceleratingToIndex:)]) {
		[_delegate stubViewDidEndDeceleratingToIndex:index];
	}
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	_isUsingScrollView = YES;
   // NSLog(@"begin drag");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	_isUsingScrollView = YES;
    
	CGFloat pageWidth = _scrollView.frame.size.width;
	int index = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    UILabel *label = [_scrollView viewWithTag:index+1];
    [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview-press.png"]]];
    [label setTextColor:[UIColor colorWithRed:00.0/255.0 green:133.0/255.0 blue:126.0/255.0 alpha:1.0]];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    
    if (index!=0) {
        UILabel *prevLabel = [_scrollView viewWithTag:index];
        [prevLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview.png"]]];
        [prevLabel setTextColor:[UIColor whiteColor]];
        [prevLabel setFont:[UIFont systemFontOfSize:12]];
    }
    
    if (index<_menus.count-1) {
        UILabel *nextLabel = [_scrollView viewWithTag:index+2];
        [nextLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview.png"]]];
        [nextLabel setTextColor:[UIColor whiteColor]];
        [nextLabel setFont:[UIFont systemFontOfSize:12]];
    }
    
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
