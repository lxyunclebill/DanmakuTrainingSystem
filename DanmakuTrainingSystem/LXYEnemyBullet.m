//
//  LXYEnemyBullet.m
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-25.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#import "LXYEnemyBullet.h"

@interface LXYEnemyBullet ()

@end

@implementation LXYEnemyBullet

#pragma mark -创建子弹

+ (instancetype)creatBullet{
	
	//	创建子弹
	LXYEnemyBullet *bullet = [LXYEnemyBullet spriteNodeWithImageNamed:@"bullet"];
	
//	//	设置子弹的物理体（判定范围）
	bullet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bullet.frame.size.width / 2 - 2];
	
	//	子弹不受重力影响
	bullet.physicsBody.dynamic =YES;
	bullet.physicsBody.affectedByGravity = NO;
	
	//	子弹高度为3
	bullet.zPosition = 4;
	
	//	使用精确碰撞检测
	bullet.physicsBody.usesPreciseCollisionDetection = YES;
	
	//	设置碰撞检测
	bullet.physicsBody.categoryBitMask = enemyBulletCategory;
	bullet.physicsBody.contactTestBitMask = playerCategory;
	bullet.physicsBody.collisionBitMask = 0;
	
	//	设置敌机子弹的名字，方便寻找（其实好像全部塞到一个节点下会比较好……这个回头再说吧）
	bullet.name = @"enemyBullet";
	
	[bullet initBulletProperty];
	
	return bullet;
}

- (void)initBulletProperty{
	
	//	初始化自定义的属性

	//	默认子弹能擦
	self.bulletIsGrazed = YES;
	
	// 子弹速度初始化为负值，表示其未被设置
	self.bulletSpeed = -1;
	
	//	子弹移动的动作设为空
	self.bulletAction = nil;
	
	//	默认子弹路径与自机无关
	self.bulletIsRelateToPlayer = NO;
	
	//	子弹将要被添加到的场景设为空
	self.bulletScene = nil;
	
	//	子弹编号设为负数，代表未设置
	self.bulletNumber = -1;	
}

- (void)initBulletShootToPlayer{
	
	self.bulletIsRelateToPlayer = YES;
}

- (CGPoint)playerPointFromBullet{
	
	//	返回自机相对于子弹的位置(以子弹作为坐标原点(0,0))
	
	CGPoint playerPoint = pointSub(self.bulletScene.player.position, self.position);
	return playerPoint;
	
}


@end
