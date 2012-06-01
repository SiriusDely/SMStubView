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
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30,0, self.bounds.size.width-60, self.bounds.size.height)];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        _scrollView.delegate = self;
		_scrollView.clipsToBounds = NO;
		_scrollView.pagingEnabled = NO;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        _scrollView.canCancelContentTouches = YES;
		[self addSubview:_scrollView];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 30, 44);
        [_leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setBackgroundColor:[UIColor clearColor]];
        [_leftButton setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"left-press.png"] forState:UIControlStateHighlighted];
        [_leftButton sizeToFit];
        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(self.bounds.size.width-30, self.bounds.origin.y, 30, 44);
        [_rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setBackgroundColor:[UIColor clearColor]];
        [_rightButton setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"right-press.png"] forState:UIControlStateHighlighted];
        [_rightButton sizeToFit];
        [self addSubview:_rightButton];
        
		_isUsingScrollView = YES;
	}
	return self;
}

/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGPoint leftButtonPoint = _leftButton.frame.origin;
    CGPoint rightButtonPoint = _rightButton.frame.origin;
	if ([self pointInside:leftButtonPoint withEvent:event]) {
        return _leftButton;
    } else if ([self pointInside:rightButtonPoint withEvent:event]){
        return _rightButton;
    } else {
        return _scrollView;
    }
    
    UITouch *touch = [event touchesForView:_scrollView];
    touch.gestureRecognizers gestureRecognizers
    if ([[event touchesForView:_scrollView] containsObject:UITouchPhaseStationary]) {
        NSLog(@"touched");
        return _scrollView;
    }
	return nil;
    
}
*/

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
        label.frame = CGRectMake(contentOffset, 0, 80, 44);
        [label setTag:i+1];
		[_scrollView addSubview:label];
        [label release];
		
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = labelFrame;
        [button addTarget:self action:@selector(labelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTag:i+11];
        [_scrollView addSubview:button];
        //[button release];
        
        if (i!=0) {
            UIImageView *border = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x-2, 0, 2, 44)];
            border.image = [UIImage imageNamed:@"line.png"];
            [_scrollView addSubview:border];
            [border release];
        }
        
		contentOffset += 82;
		_scrollView.contentSize = CGSizeMake(82*(i+1), 44);
	}
}
         
- (void)rightButtonPressed{
    if (_activeIndex < _menus.count) {
        [self scrollToIndex:_activeIndex+1];
    }
}

- (void)leftButtonPressed{
    if (_activeIndex != 1) {
        [self scrollToIndex:_activeIndex-1];
    }
}

- (void)labelButtonPressed:(id)sender{
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    NSLog(@"button %d pressed", tag);
    [self scrollToIndex:tag-10];
}

- (void)scrollToIndex:(int)index {
    NSLog(@"index: %d",index);
    UIButton *currentButton = (UIButton*)[_scrollView viewWithTag:index+10];
	CGRect frame;
	frame.origin.x = currentButton.frame.origin.x;//+(self.frame.size.width/2)-(currentButton.frame.size.width/2);
	frame.origin.y = 0;
	frame.size = currentButton.frame.size;
	[_scrollView scrollRectToVisible:frame animated:YES];
	_isUsingScrollView = NO;
	[_scrollView scrollRectToVisible:frame animated:YES];
    _activeIndex = index;
    
    UILabel *label = (UILabel*)[_scrollView viewWithTag:index];
    [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview-press.png"]]];
    [label setTextColor:[UIColor colorWithRed:00.0/255.0 green:133.0/255.0 blue:126.0/255.0 alpha:1.0]];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    
    for (int i=1; i<=_menus.count; i++) {
        UILabel *label = (UILabel*)[_scrollView viewWithTag:i];
        if (i!=index) {
            [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview.png"]]];
            [label setTextColor:[UIColor whiteColor]];
            [label setFont:[UIFont systemFontOfSize:12]];
        } else {
            [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview-press.png"]]];
            [label setTextColor:[UIColor colorWithRed:00.0/255.0 green:133.0/255.0 blue:126.0/255.0 alpha:1.0]];
            [label setFont:[UIFont boldSystemFontOfSize:12]];
        }
    }
    
    if ([_delegate respondsToSelector:@selector(stubViewDidEndDeceleratingToIndex:)]) {
		[_delegate stubViewDidEndDeceleratingToIndex:index-1];
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
    /*
	CGFloat pageWidth = _scrollView.frame.size.width;
	int index = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    for (int i=1; i<_menus.count; i++) {
        UILabel *label = (UILabel*)[_scrollView viewWithTag:i];
        if (i!=index+1) {
            [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview.png"]]];
            [label setTextColor:[UIColor whiteColor]];
            [label setFont:[UIFont systemFontOfSize:12]];
        } else {
            [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stubview-press.png"]]];
            [label setTextColor:[UIColor colorWithRed:00.0/255.0 green:133.0/255.0 blue:126.0/255.0 alpha:1.0]];
            [label setFont:[UIFont boldSystemFontOfSize:12]];
        }
    }
     */
    /*    
	if ([_delegate respondsToSelector:@selector(stubViewDidEndDeceleratingToIndex:)]) {
		[_delegate stubViewDidEndDeceleratingToIndex:index];
	}
    */
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (_activeIndex <= 0) _leftView.hidden = YES;
	else _leftView.hidden = NO;
	if (_activeIndex >= (_menus.count)) _rightView.hidden = YES;
	else _rightView.hidden = NO;
}

@end
