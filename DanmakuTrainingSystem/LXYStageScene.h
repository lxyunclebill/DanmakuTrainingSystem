//
//  LXYStageScene.h
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-25.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LXYPlayer.h"
#import "LXYPlayerBullet.h"
#import "LXYEnemyBullet.h"
#import "LXYEnemy.h"

@class LXYEnemy;
@class LXYEnemyBullet;

@interface LXYStageScene : SKScene<SKPhysicsContactDelegate>

//	自机
@property (nonatomic) LXYPlayer *player;
//	敌机编号，每关开始的时候初始化为1，每增加一个敌机就＋1，敌机消失也不减小
@property (nonatomic) int enemyNumber;

#pragma mark -初始化方法

-(instancetype)initWithSize:(CGSize)size;
- (void)initPlayer;
- (void)initPhysicsWorld;

@end
