//
//  STWViewController.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 17/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWViewController.h"
#import "STWMyScene.h"


@interface STWViewController ()

@property (nonatomic,retain) SKView *sceneView;

@end


@implementation STWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    //SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
	
	self.sceneView = [[SKView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:self.sceneView];
    
    // Create and configure the scene.
    STWMyScene * scene = [STWMyScene sceneWithSize:CGSizeMake(self.view.bounds.size.width*2., self.view.bounds.size.height)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = (id<STWSceneDelegate>)self;
	
    // Present the scene.
    [self.sceneView presentScene:scene];
	CGRect frame = self.sceneView.frame;
	frame.size = CGSizeMake(scene.frame.size.width, scene.frame.size.height);
	self.sceneView.frame = frame;
}


//- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	UITouch *aTouch = [touches anyObject];
//	CGPoint touchPosition = [aTouch locationInView:self.sceneView];
//	CGFloat x = -touchPosition.x;
//	
//	// Make sure that only nothing outside the scene gets displayed
//	if (-x < (self.view.frame.size.width/2.0)) {
//		x = -(self.view.frame.size.width/2.0);
//	}
//	else if (-x > self.sceneView.frame.size.width - (self.view.frame.size.width / 2.0)) {
//		x = -(self.sceneView.frame.size.width - (self.view.frame.size.width / 2.0));
//	}
//		
//	[UIView animateWithDuration:0.2 animations:^(void){
//		self.sceneView.frame = CGRectMake(x +(self.view.frame.size.width / 2.0),
//										  self.sceneView.frame.origin.y, self.sceneView.frame.size.width, self.sceneView.frame.size.height);
//	}];
//}


- (void) scene:(STWMyScene *)scene didPositionMainCharacter:(CGPoint)position duration:(NSTimeInterval)duration
{
	CGFloat x = -position.x;
	
	// Make sure that only nothing outside the scene gets displayed
	if (-x < (self.view.frame.size.width/2.0)) {
		x = -(self.view.frame.size.width/2.0);
	}
	else if (-x > self.sceneView.frame.size.width - (self.view.frame.size.width / 2.0)) {
		x = -(self.sceneView.frame.size.width - (self.view.frame.size.width / 2.0));
	}
	
	[UIView animateWithDuration:duration animations:^(void){
		self.sceneView.frame = CGRectMake(x +(self.view.frame.size.width / 2.0),
										  self.sceneView.frame.origin.y, self.sceneView.frame.size.width, self.sceneView.frame.size.height);
	}];
}



- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
