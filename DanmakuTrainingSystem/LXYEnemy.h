//
//  LXYEnemy.h
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-25.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LXYEnemyBullet.h"
#import "LXYStageScene.h"

@class LXYStageScene;

@interface LXYEnemy : SKSpriteNode

//	敌机血量
@property (nonatomic) int enemyLife;
//	敌机身上带有的子弹
@property (nonatomic) NSMutableArray *enemyBulletArray;
//	是否无限循环放弹幕
@property (nonatomic) BOOL enemyLoopShoot;
//	敌机移动的动作
@property (nonatomic) SKAction *enemyAction;
//	敌机移动的速度
@property (nonatomic) float enemySpeed;
//	敌机将会被添加到的场景
@property (nonatomic) LXYStageScene *enemyScene;
//	敌机的编号，用于击破敌机时消除该敌机弹幕
@property (nonatomic) int enemyNumber;

+ (instancetype)creatEnemy;

- (void)shoot;

@end
