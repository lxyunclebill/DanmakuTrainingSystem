//
//  LXYPlayerBullet.m
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-25.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#import "LXYPlayerBullet.h"

@interface LXYPlayerBullet ()

@end

@implementation LXYPlayerBullet

#pragma mark -创建子弹

+ (instancetype)creatBullet{
	
	//	创建子弹
	LXYPlayerBullet *bullet = [LXYPlayerBullet spriteNodeWithImageNamed:@"playerBullet"];
	
//	//	设置子弹的物理体（判定范围）
//	bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.frame.size];
//	
//	//	子弹不受重力影响
//	bullet.physicsBody.dynamic =YES;
//	bullet.physicsBody.affectedByGravity = NO;
	
	//	子弹高度为1
	bullet.zPosition = 1;
	
//	//	使用精确碰撞检测
//	bullet.physicsBody.usesPreciseCollisionDetection = YES;
//	
//	//	设置碰撞检测
//	bullet.physicsBody.categoryBitMask = playerBulletCategory;
//	bullet.physicsBody.contactTestBitMask = enemyCategory;
//	bullet.physicsBody.collisionBitMask = 0;
	
	//	设置自机子弹的名字，方便寻找（其实好像全部塞到一个节点下会比较好……这个回头再说吧）
	bullet.name = @"playerBullet";
	
	[bullet initBulletProperty];
	
	return bullet;
}

- (void)initBulletProperty{
	
	//	初始化自定义的属性
	
	//	子弹的威力初始化为负值，代表未设置
	self.bulletDamage = -1;
	
	// 子弹速度初始化为负值，表示其未被设置
	self.bulletSpeed = -1;
	
	//	子弹移动的动作设为空
	self.bulletAction = nil;
	
	//	子弹将要被添加到的场景设为空
	self.bulletScene = nil;
}

- (id)copy{
	
	LXYPlayerBullet *playerBullet = [super copy];
	
	playerBullet.bulletDamage = self.bulletDamage;
	playerBullet.bulletSpeed = self.bulletSpeed;
	playerBullet.bulletAction = self.bulletAction;
	playerBullet.bulletScene = self.bulletScene;
	
	return playerBullet;
}

@end
