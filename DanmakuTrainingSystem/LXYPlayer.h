//
//  LXYPlayer.h
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-25.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LXYPlayer : SKSpriteNode

//	自机的子弹
@property (nonatomic) NSMutableArray *playerBulletArray;
//	每过多少帧发射一次
@property (nonatomic) int playerShootBulletFrame;

+ (instancetype)creatPlayer;

@end
