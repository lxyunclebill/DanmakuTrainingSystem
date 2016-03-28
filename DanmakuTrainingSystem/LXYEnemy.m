//
//  LXYEnemy.m
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-25.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#import "LXYEnemy.h"

@interface LXYEnemy ()

@end

@implementation LXYEnemy

#pragma mark -创建敌机

+ (instancetype)creatEnemy{
	
	//	创建敌机
	LXYEnemy *enemy = [LXYEnemy spriteNodeWithImageNamed:@"enemy"];
	
	//	设置敌机的物理体（判定范围）
	enemy.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemy.frame.size.width / 2 - 2];
	
	//	敌机不受重力影响
	enemy.physicsBody.dynamic =YES;
	enemy.physicsBody.affectedByGravity = NO;
	
	//	敌机高度为3
	enemy.zPosition = 3;
	
	//	不使用精确碰撞检测
	enemy.physicsBody.usesPreciseCollisionDetection = NO;
	
	//	设置碰撞检测
	enemy.physicsBody.categoryBitMask = enemyCategory;
	enemy.physicsBody.contactTestBitMask = playerCategory;
	enemy.physicsBody.collisionBitMask = playerBulletCategory;
	
	//	设置敌机的名字，方便寻找（其实好像全部塞到一个节点下会比较好……这个回头再说吧）
	enemy.name = @"enemy";
	
	[enemy initEnemyProperty];
	 
	return enemy;
}

- (void)initEnemyProperty{
	
	//	初始化自定义的属性
	
	//	初始化血量为负，代表未设置
	self.enemyLife = -1;
	
	//	初始化敌机身上携带的子弹(暂为空可变数组)
	self.enemyBulletArray = [[NSMutableArray alloc] init];
	
	//	默认不循环放弹幕
	self.enemyLoopShoot = NO;
	
	//	初始化动作为空
	self.enemyAction =nil;
	
	//	初始化敌机移动速度为负，表示未设置
	self.enemySpeed = -1;
	
	//	初始化将要被添加到的场景为空
	self.enemyScene = nil;
	
	//	初始化编号为负数，代表未设置
	self.enemyNumber = -1;
}

- (void)shoot{
	
	for (LXYEnemyBullet *bullet in self.enemyBulletArray) {
		
		
		if (bullet.bulletIsRelateToPlayer) {
			
			//	设置子弹移动的轨迹
			
			//	起始点为敌机坐标
			bullet.position = self.position;
			
			CGMutablePathRef bulletPath = CGPathCreateMutable();
			
			//	在使用CGpath的SKAction中，使用的是执行动作的节点的坐标系，所以起始点设为(0，0)表示的是从敌机的坐标上发射子弹，这也是最常见的一种子弹发射点，如果希望子弹发射点相对敌机固定或者相对屏幕固定，可以将一个看不见的Node添加为敌机/场景的子节点，作为发射点使用。
			CGPathMoveToPoint(bulletPath, nil, 0,0);
			
			//	计算子弹指向自机的单位向量，将其乘以1000保证子弹能飞出屏幕
			CGPoint realPoint = pointMult(pointNormalize(pointSub(self.enemyScene.player.position,bullet.position)),1000);
			CGPathAddLineToPoint(bulletPath, nil, realPoint.x, realPoint.y);
			
			SKAction *moveAction =[SKAction followPath:bulletPath duration:1000 / bullet.bulletSpeed];
			SKAction *moveOverAction = [SKAction removeFromParent];
			bullet.bulletAction = [SKAction sequence:@[moveAction,moveOverAction]];
			
			CGPathRelease(bulletPath);
			
		}
		
		[self.parent addChild:bullet];
		[bullet runAction:bullet.bulletAction];
	}
}

@end
