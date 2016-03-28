//
//  LXYPlayer.m
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-25.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#import "LXYPlayer.h"

@interface LXYPlayer ()

//	自机背景
@property (nonatomic) SKSpriteNode *playerBackground;
//	自机火力等级
@property (nonatomic) int playerPower;

@end

@implementation LXYPlayer

#pragma mark -创建自机

+ (instancetype)creatPlayer{
	
	//	创建自机（包括背景）
	LXYPlayer *player = [LXYPlayer spriteNodeWithImageNamed:@"reimu"];
	player.playerBackground = [SKSpriteNode spriteNodeWithImageNamed:@"playerBackground"];
	[player addChild:player.playerBackground];
	
	//	设置自机的物理体（判定范围和擦弹范围）
	player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:2.0];
	player.playerBackground.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.playerBackground.frame.size.width / 2 - 2];
	
	//	设置碰撞检测
	//	背景魔法阵没有任何判定
	player.playerBackground.physicsBody.categoryBitMask = 0;
	player.playerBackground.physicsBody.contactTestBitMask = 0;
	player.playerBackground.physicsBody.collisionBitMask = 0;
	
	//	自机与敌机和敌机子弹碰撞
//	player.physicsBody.categoryBitMask = playerCategory;
	player.physicsBody.categoryBitMask = 0;
//	player.physicsBody.contactTestBitMask = (enemyCategory | enemyBulletCategory);
	player.physicsBody.contactTestBitMask = 0;
	player.physicsBody.collisionBitMask = 0;
	
	//	自机不受重力影响
	player.physicsBody.dynamic = YES;
	player.physicsBody.affectedByGravity = NO;
	player.playerBackground.physicsBody.dynamic = YES;
	player.playerBackground.physicsBody.affectedByGravity = NO;
	
	//	使用精确碰撞检测
	player.playerBackground.physicsBody.usesPreciseCollisionDetection = player.physicsBody.usesPreciseCollisionDetection = YES;
	
	//	自机高度为2
	player.zPosition = 2;
	
	//	自机背景高度相对自机为1
	player.playerBackground.zPosition = 1;
	
	//	自机背景无限自转
	SKAction *rotateAction = [SKAction rotateByAngle:M_PI duration:1];
	SKAction *rotateForeverAction = [SKAction repeatActionForever:rotateAction];
	[player.playerBackground runAction:rotateForeverAction];
	
	//	设置自机的名字，方便寻找（其实也就一个自机吧……找你妹，强迫症没得救）
	player.name = @"player";
	
	[player initPlayerProperty];
	
	return player;
}

- (void)initPlayerProperty{
	
	//	初始化自定义的属性
	
	//	自机子弹初始化（暂为空可变数组）
	self.playerBulletArray = [[NSMutableArray alloc] init];
	
	//	自机火力为1
	self.playerPower = 1;
	
	//	每过多少帧发射一次子弹，设为负数代表未设置
	self.playerShootBulletFrame = -1;
}

@end