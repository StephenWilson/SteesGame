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
    STWMyScene * scene = [STWFirstScene sceneWithSize:CGSizeMake(640., 480.)];
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
	STWMyScene *scene = nil;
	if ([skView.scene isKindOfClass:[STWFirstScene class]]) {
		scene = [STWSecondScene sceneWithSize:CGSizeMake(640., 480.)];
	}
	else {
		scene = [STWFirstScene sceneWithSize:CGSizeMake(640., 480.)];
	}
	
	scene.scaleMode = SKSceneScaleModeAspectFill;
	((STWMyScene *)scene).delegate = (id<STWSceneDelegate>)self;
	
    // Present the scene.
    [skView presentScene:scene transition:[SKTransition doorwayWithDuration:1.0]];
}

- (IBAction)weaponise:(id)sender {
	
	SKView *skView = (SKView *)self.view;
	STWMyScene *scene = (STWMyScene *)[skView scene];
	
	[scene toggleWeapon];
}
@end
