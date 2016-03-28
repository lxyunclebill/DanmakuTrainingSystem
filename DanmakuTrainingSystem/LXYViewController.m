//
//  LXYViewController.m
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-25.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#import "LXYViewController.h"

@implementation LXYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //	设置SKview，显示各种信息，每秒60帧
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
	skView.showsDrawCount = YES;
//	skView.showsPhysics = YES;
	skView.frameInterval = 1;
    
    //	创建一个场景并进行设置
    LXYStageScene *stageScene = [LXYStageScene sceneWithSize:skView.bounds.size];
    stageScene.scaleMode = SKSceneScaleModeAspectFill;
    
    //	把场景推送到SKview上
    [skView presentScene:stageScene];
    
	//	设置一个暂停按钮
    UIButton *button = [[UIButton alloc]init];
    button.bounds = CGRectMake(0,0,50,50);
	button.frame = CGRectMake(10, 25, 50, 50);
    [button setTitle:@"暂停" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.layer setBorderWidth:2.0];
    [button.layer setCornerRadius:15.0];
    [button.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [button addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
	
//	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameOver) name:@"gameOverNotification" object:nil];
	
	//	直接在scene里面restart不能正常初始化自机位置，临时加了一个通知，看名字就知道我是什么心情了
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(miss) name:@"FuckYouNotification" object:nil];

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

- (void)pause{
	
	//	先判断是否处于暂停状态之中，如是则不做任何操作
	if (((SKView *)self.view).paused == NO) {
		
		((SKView *)self.view).paused = YES;
		
		UIView *pauseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
		
		UIButton *button1 = [[UIButton alloc]init];
		[button1 setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100,50,200,30)];
		[button1 setTitle:@"继续" forState:UIControlStateNormal];
		[button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button1.layer setBorderWidth:2.0];
		[button1.layer setCornerRadius:15.0];
		[button1.layer setBorderColor:[[UIColor grayColor] CGColor]];
		[button1 addTarget:self action:@selector(continueGame:) forControlEvents:UIControlEventTouchUpInside];
		[pauseView addSubview:button1];
		
		UIButton *button2 = [[UIButton alloc]init];
		[button2 setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100,100,200,30)];
		[button2 setTitle:@"重新开始" forState:UIControlStateNormal];
		[button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button2.layer setBorderWidth:2.0];
		[button2.layer setCornerRadius:15.0];
		[button2.layer setBorderColor:[[UIColor grayColor] CGColor]];
		[button2 addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
		[pauseView addSubview:button2];
		
		pauseView.center = self.view.center;
		
		[self.view addSubview:pauseView];
	}

}

- (void)restart:(UIButton *)button{
	
	
    [button.superview removeFromSuperview];
    ((SKView *)self.view).paused = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"restartNotification" object:nil];
}

- (void)continueGame:(UIButton *)button{
    [button.superview removeFromSuperview];
    ((SKView *)self.view).paused = NO;
}

- (void)miss{
		
	if (((SKView *)self.view).paused == NO) {
	
		((SKView *)self.view).paused = YES;
		
		UIView *pauseView = [[UIView alloc]initWithFrame:self.view.frame];
		
		UIButton *button2 = [[UIButton alloc]init];
		[button2 setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100,CGRectGetHeight(self.view.frame)/2,200,30)];
		[button2 setTitle:@"重新开始" forState:UIControlStateNormal];
		[button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button2.layer setBorderWidth:2.0];
		[button2.layer setCornerRadius:15.0];
		[button2.layer setBorderColor:[[UIColor grayColor] CGColor]];
		[button2 addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
		[pauseView addSubview:button2];
		
		pauseView.center = self.view.center;
		
		[self.view addSubview:pauseView];
	}
	
}

@end
