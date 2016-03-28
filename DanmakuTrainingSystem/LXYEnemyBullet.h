//
//  LXYEnemyBullet.h
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-25.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LXYPlayer.h"
#import "LXYStageScene.h"

@class LXYStageScene;

@interface LXYEnemyBullet : SKSpriteNode

//	子弹是否已擦
@property (nonatomic) BOOL bulletIsGrazed;
//	子弹移动的速度，以（point/每秒）为单位
@property (nonatomic) float bulletSpeed;
//	子弹移动的动作
@property (nonatomic) SKAction *bulletAction;
//	子弹是否跟自机有关（跟自机有关的弹幕在最终射出前才能决定路径，随敌机初始化的时候无法决定，所以需要一个标记，判断子弹在最终射出前是否需要计算路径）
@property (nonatomic) BOOL bulletIsRelateToPlayer;
//	子弹将会被添加到的场景
@property (nonatomic) LXYStageScene *bulletScene;
//	子弹的编号，判断子弹由哪架敌机射出，用于击破敌机时消除该敌机弹幕
@property (nonatomic) int bulletNumber;

+ (instancetype)creatBullet;

- (void)initBulletShootToPlayer;

@end
