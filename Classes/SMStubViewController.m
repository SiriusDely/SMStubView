#import "SMStubViewController.h"

@implementation SMStubViewController

- (void)dealloc {
	[_label release];
	[_stubView release];
	[super dealloc];
}

- (void)viewDidLoad {
	_stubView = [[SMStubView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+100, 320, 23)];
	_stubView.delegate = self;
	[self.view addSubview:_stubView];
	
	NSArray *menus = [NSArray arrayWithObjects:@"menu 1", @"menu 2", @"menu 3", @"menu 4", @"menu 5", @"menu 6", @"menu 7", @"menu 8", nil];
	
	[_stubView setMenus:menus];		// Why is this generates warning?
	
	_label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x-40, self.view.center.y-80, 80, 80)];
	_label.backgroundColor = [UIColor clearColor];
	_label.textAlignment = UITextAlignmentCenter;
	_label.font = [UIFont fontWithName:@"Helvetica-Bold" size:80];
	_label.text = @"1";
	[self.view addSubview:_label];
}

- (void)stubViewDidEndDeceleratingToIndex:(int)index {
	_label.text = [NSString stringWithFormat:@"%d", index+1];
}

@end
