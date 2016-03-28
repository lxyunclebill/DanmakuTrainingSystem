//
//  LXYPlayerBullet.h
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-25.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LXYStageScene.h"

@class LXYStageScene;

@interface LXYPlayerBullet : SKSpriteNode

//	子弹的威力（伤害值）
@property (nonatomic) int bulletDamage;
//	子弹移动的速度，以（point/每秒）为单位
@property (nonatomic) float bulletSpeed;
//	子弹移动的动作
@property (nonatomic) SKAction *bulletAction;
//	子弹将会被添加到的场景
@property (nonatomic) LXYStageScene *bulletScene;

+ (instancetype)creatBullet;



@end
