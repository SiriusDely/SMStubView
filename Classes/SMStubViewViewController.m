#import "SMStubViewViewController.h"

@implementation SMStubViewViewController

- (void)dealloc {
	[_label release];
	[_viewStub release];
	[super dealloc];
}

- (void)viewDidLoad {
	_viewStub = [[SMStubView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 320, 23)];
	_viewStub.delegate = self;
	[self.view addSubview:_viewStub];
	
	NSArray *texts = [NSArray arrayWithObjects:@"menu 1", @"menu 2", @"menu 3", @"menu 4", @"menu 5", @"menu 6", @"menu 7", @"menu 8", nil];
	CGFloat contentOffset = 0;
	for (unsigned i=0; i<texts.count; i++) {
		NSString *text = [texts objectAtIndex:i];
		
		CGRect labelFrame = CGRectMake(contentOffset, 0, 160, 23);
		UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.text = text;
		[_viewStub.scrollView addSubview:label];
		[label release];
		
		contentOffset += 160;
		_viewStub.scrollView.contentSize = CGSizeMake(160*(i+1), 23);
	}
	_label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x-40, self.view.center.y-80, 80, 80)];
	_label.backgroundColor = [UIColor clearColor];
	_label.textAlignment = UITextAlignmentCenter;
	_label.font = [UIFont fontWithName:@"Helvetica-Bold" size:80];
	_label.text = @"1";
	[self.view addSubview:_label];
}

- (void)viewStubDidEndDeceleratingToIndex:(int)index {
	_label.text = [NSString stringWithFormat:@"%d", index+1];
}

@end
