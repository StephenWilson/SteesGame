//
//  STWViewController.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 17/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWViewController.h"
#import "STWMyScene.h"
#import "STWFirstScene.h"
#import "STWSecondScene.h"


@interface STWViewController ()

@property (nonatomic,retain) SKView *sceneView;

@end


@implementation STWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    // Create and configure the scene.
    STWFirstScene * scene = [STWFirstScene sceneWithSize:CGSizeMake(self.view.bounds.size.width*2., self.view.bounds.size.height)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = (id<STWSceneDelegate>)self;
	
    // Present the scene.
    [skView presentScene:scene];
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

- (IBAction)reset:(id)sender {
	
	SKView * skView = (SKView *)self.view;
	
	// Create and configure the scene.
    STWSecondScene * scene = [STWSecondScene sceneWithSize:CGSizeMake(self.view.bounds.size.width*2., self.view.bounds.size.height)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = (id<STWSceneDelegate>)self;
	
    // Present the scene.
    [skView presentScene:scene];
}
@end
