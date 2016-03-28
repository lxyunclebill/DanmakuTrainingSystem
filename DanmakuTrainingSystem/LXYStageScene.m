//
//  LXYStageScene.m
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-25.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#import "LXYStageScene.h"
#define SHOOTFRAME 6
#define ENEMYFRAME 6

@interface LXYStageScene ()

//	本关得分
@property (nonatomic) int stageScore;
//	总分
@property (nonatomic) int totalScore; 
//	关卡序号
@property (nonatomic) int stage;
//	触摸点开始的位置，用于计算自机移动
@property (nonatomic) CGPoint touchBeganPoint;
//	触摸开始时自机的位置，用于计算自机移动
@property (nonatomic) CGPoint touchBeganPlayerPoint;
//	临时偷懒的属性，多少帧出一个敌人，这个属性过两天就删，重构掉
@property (nonatomic) int addEnemyFrame;
//	临时偷懒的属性，你淦死了多少敌人，这个属性过两天就删，重构掉
@property  (nonatomic) int killEnemyNumber;

@end

@implementation LXYStageScene

#pragma mark -初始化

-(instancetype)initWithSize:(CGSize)size {
    
	if (self = [super initWithSize:size]) {
        
		//	背景色为白色
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		
		//	初始化场景的物理世界
		[self initPhysicsWorld];
		
		//	初始化自机
		[self initPlayer];
		
		self.stage = 1;
		self.enemyNumber = 1;
		self.addEnemyFrame = ENEMYFRAME;
		self.killEnemyNumber = 0;
		self.stageScore = 0;
		
		//	注册到通知中心，使用观察者模式监视重新开始的信号
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restart) name:@"restartNotification" object:nil];
		
		//	直接在scene里面restart不能正常初始化自机位置，临时加了一个通知，看名字就知道我是什么心情了
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showInformation) name:@"FuckYouNotification" object:nil];
    }
    return self;
}

- (void)initPlayer{
	
	//	创建一个自机
	self.player = [LXYPlayer creatPlayer];
	
	//	自机位置为屏幕下方正中
	self.player.position = CGPointMake(self.frame.size.width / 2, self.player.frame.size.height / 2 + 20);
	
	//	每秒发射十次子弹
	self.player.playerShootBulletFrame = SHOOTFRAME;
	
	
	//	自机发射子弹，方向正上，一颗
	
	for (int i = 0; i < 1; i++) {
		
		//	自机火力为一颗子弹，从自机的位置向正上方发射
		LXYPlayerBullet *playerBullet = [LXYPlayerBullet creatBullet];
		
		//	设置子弹将要被添加到此场景
		playerBullet.bulletScene = self;
		
		//	设置自机子弹的移动速度，自机子弹的移动速度需要非常快
		playerBullet.bulletSpeed = 500;
		
		//	把子弹添加到自机的子弹数组里面
		[self.player.playerBulletArray addObject:playerBullet];
	}
	
	//	把自机添加为场景的子节点
	[self addChild:self.player];
}

- (void)initPhysicsWorld{
	
	//	设置场景重力（仅用于创建星弧破碎那样的弹幕）
	self.physicsWorld.gravity = CGVectorMake(0.0, -1.0);
	
	//	设置碰撞检测代理为该场景
	self.physicsWorld.contactDelegate = self;
	
	//	为场景添加边界
	self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
	self.physicsBody.categoryBitMask = sceneEdgeCategory;
	self.physicsBody.contactTestBitMask = 0;
	self.physicsBody.collisionBitMask = 0;
}

- (void)restart{
	
	//	移除场景中所有子结点和动作（恢复成空场景）
	[self removeAllChildren];
	[self removeAllActions];
	
	//	恢复各种自定义属性为默认值
	self.stage = 1;
	self.enemyNumber = 1;
	self.addEnemyFrame = ENEMYFRAME;
	self.killEnemyNumber = 0;
	self.stageScore = 0;
	self.touchBeganPlayerPoint = CGPointZero;
	self.touchBeganPoint = CGPointZero;
	
	//	初始化自机
	[self initPlayer];
	self.enemyNumber = 1;
}

#pragma mark -自机移动

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	for (UITouch *touch in touches) {
		
		//	记录触摸开始的时候自机的位置及触摸点，用于移动自机
		self.touchBeganPoint = [touch locationInNode:self];
		self.touchBeganPlayerPoint = self.player.position;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        
        CGPoint touchPoint = [touch locationInNode:self];
        
        if (touchPoint.x >= self.size.width - (self.player.size.width / 2)) {
            
            touchPoint.x = self.size.width - (self.player.size.width / 2);
            
        }else if (touchPoint.x <= (self.player.size.width / 2)) {
            
            touchPoint.x = self.player.size.width / 2;
            
        }
        
        if (touchPoint.y >= self.size.height - (self.player.size.height / 2)) {
            
            touchPoint.y = self.size.height - (self.player.size.height / 2);
            
        }else if (touchPoint.y <= (self.player.size.height / 2)) {
            
            touchPoint.y = (self.player.size.height / 2);
            
        }
		
		//	自机移动与触摸点移动一致
		CGPoint targetPoint = CGPointMake(touchPoint.x + self.touchBeganPlayerPoint.x - self.touchBeganPoint.x, touchPoint.y + self.touchBeganPlayerPoint.y - self.touchBeganPoint.y);
		
		//	如果移动地点超出了屏幕边界的话就修改目标地点，把自机限制在屏幕里面
		while (1) {
			
			if (targetPoint.x < 0 + 2) {
				targetPoint.x = 0 + 2;
				continue;
			}else if (targetPoint.x > 320 - 2) {
				targetPoint.x = 320 - 2;
				continue;
			}else if (targetPoint.y < 0 + 2){
				targetPoint.y = 0+ 2;
				continue;
			}else if (targetPoint.y > 568 - 2){
				targetPoint.y = 568 - 2;
				continue;
			}else{
				break;
			}
		}
		
		SKAction *moveToAction = [SKAction moveTo:targetPoint duration:0];
        
        [self.player runAction:moveToAction];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	
	;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	;
}

#pragma mark -更新场景

- (void)update:(NSTimeInterval)currentTime{
	
	switch (self.stage) {
		case 1:
			[self updateStage1:currentTime];
			break;
			
		default:
			break;
	}
	self.stageScore++;
}

- (void)updateStage1:(NSTimeInterval)currentTime{

	if (self.addEnemyFrame == 0) {
		
		[self addEnemyStraightFromLeftToRight];
		[self addEnemyStraightFromLRightToLeft];
		
		self.addEnemyFrame = ENEMYFRAME;
	}else{
		
		self.addEnemyFrame--;
	}
	
	if (self.player.playerShootBulletFrame == 0) {
		
		for (LXYPlayerBullet *playerBullet in self.player.playerBulletArray) {
			
			LXYPlayerBullet *realPlayerBullet = [playerBullet copy];
			
			realPlayerBullet.position = self.player.position;
			
			
			//	设置自机子弹移动轨迹
			CGMutablePathRef playerBulletPath = CGPathCreateMutable();
			CGPathMoveToPoint(playerBulletPath, nil, realPlayerBullet.position.x,realPlayerBullet.position.y);
			CGPathAddLineToPoint(playerBulletPath, nil, realPlayerBullet.position.x, 1000);
			
			//	设置动作为向正上方发射然后消失
			SKAction *moveAction = [SKAction followPath:playerBulletPath asOffset:NO orientToPath:NO duration:1000 / realPlayerBullet.bulletSpeed];
			SKAction *moveOverAction = [SKAction removeFromParent];
			realPlayerBullet.bulletAction = [SKAction sequence:@[moveAction,moveOverAction]];
			
			CGPathRelease(playerBulletPath);
			
			[realPlayerBullet.bulletScene addChild:realPlayerBullet];
			
			[realPlayerBullet runAction:realPlayerBullet.bulletAction];
		}
		
		self.player.playerShootBulletFrame = SHOOTFRAME;
	}else{
		self.player.playerShootBulletFrame--;
	}
	
}

#pragma mark -详细设定敌机，暂放这里

- (void)addEnemyStraightFromLeftToRight{
	
	//	在屏幕上方生成从左往右水平移动，速度恒定的敌机
		
	//	创建敌机
	LXYEnemy *enemy = [LXYEnemy creatEnemy];
	enemy.position = CGPointMake(0 - enemy.frame.size.width / 2,450 + arc4random() % 50);
	
	//	设置敌机将要添加到此场景，为敌机设定唯一的敌机编号
	enemy.enemyScene = self;
	enemy.enemyNumber = self.enemyNumber;
	self.enemyNumber++;
	
	

	//	设置敌机的移动速度，以（point/每秒）为单位
	enemy.enemySpeed = 200;
	
	//	暂定1发自机狙，不循环
	enemy.enemyLoopShoot = NO;
	
	for (int i = 0; i < 10; i++) {
		
		LXYEnemyBullet *bullet = [LXYEnemyBullet creatBullet];
		[bullet initBulletShootToPlayer];
		bullet.bulletNumber = enemy.enemyNumber;
		bullet.bulletScene = enemy.enemyScene;
		bullet.bulletSpeed = 200 + 10 * i;
		[enemy.enemyBulletArray addObject:bullet];
	}
	
	
	//	设置敌机移动轨迹
	CGMutablePathRef enemyPath = CGPathCreateMutable();
	CGPathMoveToPoint(enemyPath, nil, enemy.position.x,enemy.position.y);
	
	//	水平移动到屏幕外
	CGPoint realPoint = CGPointMake(enemy.position.x + 320 + enemy.frame.size.width,enemy.position.y);
	CGPathAddLineToPoint(enemyPath, nil, realPoint.x, realPoint.y);
	
	SKAction *moveAction = [SKAction followPath:enemyPath asOffset:NO orientToPath:NO duration:2.0];
	SKAction *moveOverAction = [SKAction removeFromParent];
	
	//	在屏幕上方，左侧屏幕外生成敌机

	[self addChild:enemy];
	[enemy runAction:[SKAction sequence:@[moveAction,moveOverAction]]];
	
	CGPathRelease(enemyPath);
	
	[enemy performSelector:@selector(shoot) withObject:nil afterDelay:0.0 + (arc4random() % 1000) / 500.0];
}

- (void)addEnemyStraightFromLRightToLeft{
	
	//	在屏幕上方生成从右往左水平移动，速度恒定的敌机
	
	//	创建敌机
	LXYEnemy *enemy = [LXYEnemy creatEnemy];
	enemy.position = CGPointMake(self.frame.size.width + enemy.frame.size.width / 2,450 + arc4random() % 50);
	
	//	设置敌机将要添加到此场景，为敌机设定唯一的敌机编号
	enemy.enemyScene = self;
	enemy.enemyNumber = self.enemyNumber;
	self.enemyNumber++;
	
	
	
	//	设置敌机的移动速度，以（point/每秒）为单位
	enemy.enemySpeed = 200;
	
	//	暂定1发自机狙，不循环
	enemy.enemyLoopShoot = NO;
	
	for (int i = 0; i < 10; i++) {
		
		LXYEnemyBullet *bullet = [LXYEnemyBullet creatBullet];
		[bullet initBulletShootToPlayer];
		bullet.bulletNumber = enemy.enemyNumber;
		bullet.bulletScene = enemy.enemyScene;
		bullet.bulletSpeed = 200 + 10 * i;
		[enemy.enemyBulletArray addObject:bullet];
	}
	
	
	//	设置敌机移动轨迹
	CGMutablePathRef enemyPath = CGPathCreateMutable();
	CGPathMoveToPoint(enemyPath, nil, enemy.position.x,enemy.position.y);
	
	//	水平移动到屏幕外
	CGPoint realPoint = CGPointMake(enemy.position.x - 320 - enemy.frame.size.width,enemy.position.y);
	CGPathAddLineToPoint(enemyPath, nil, realPoint.x, realPoint.y);
	
	SKAction *moveAction = [SKAction followPath:enemyPath asOffset:NO orientToPath:NO duration:2.0];
	SKAction *moveOverAction = [SKAction removeFromParent];
	
	//	在屏幕上方，左侧屏幕外生成敌机
	
	[self addChild:enemy];
	[enemy runAction:[SKAction sequence:@[moveAction,moveOverAction]]];
	
	CGPathRelease(enemyPath);
	
	[enemy performSelector:@selector(shoot) withObject:nil afterDelay:0.0 + (arc4random() % 1000) / 500.0];
}

#pragma mark -设置碰撞检测

- (void)didBeginContact:(SKPhysicsContact *)contact{
	
	// 发生碰撞时调用
	SKPhysicsBody *firstBody, *secondBody;
	
	// 传进来的两个物体顺序不确定，先排序一下，掩码小的在前面好了
	if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
		
		firstBody = contact.bodyA;
		secondBody = contact.bodyB;
	}else{
		
		firstBody = contact.bodyB;
		secondBody = contact.bodyA;
	}
	
	// 判断碰撞类型并调用相对应的方法
	if (firstBody.categoryBitMask == playerCategory) {
		
		if (secondBody.categoryBitMask == enemyCategory) {
			
			[self player:(LXYPlayer *)firstBody.node didContactWithEnemy:(LXYEnemy *)secondBody.node];
		}else if (secondBody.categoryBitMask == enemyBulletCategory){
			
			[self player:(LXYPlayer *)firstBody.node didContactWithEnemyBullet:(LXYEnemyBullet *)secondBody.node];
		}
		
	} else if (firstBody.categoryBitMask == playerBulletCategory){
		
		if (secondBody.categoryBitMask == enemyCategory) {
			
			[self playerBullet:(LXYPlayerBullet *)firstBody.node didContactWithEnemy:(LXYEnemy *)secondBody.node];
		}
	}
}

- (void)player:(LXYPlayer *)player didContactWithEnemy:(LXYEnemy *)enemy{
	
//	[player removeAllActions];
//	[player removeAllChildren];
//	[player removeFromParent];
//	[enemy removeAllActions];
//	[enemy removeAllChildren];
//	[enemy removeFromParent];
	
	//	直接在scene里面restart不能正常初始化自机位置，临时加了一个通知，看名字就知道我是什么心情了
    [[NSNotificationCenter defaultCenter]postNotificationName:@"FuckYouNotification" object:nil];
//	NSLog(@"player contact with enemy");
}

- (void)player:(LXYPlayer *)player didContactWithEnemyBullet:(LXYEnemyBullet *)enemyBullet{
	
//	[player removeAllActions];
//	[player removeAllChildren];
//	[player removeFromParent];
//	[enemyBullet removeAllActions];
//	[enemyBullet removeAllChildren];
//	[enemyBullet removeFromParent];
	
	//	直接在scene里面restart不能正常初始化自机位置，临时加了一个通知，看名字就知道我是什么心情了
	[[NSNotificationCenter defaultCenter]postNotificationName:@"FuckYouNotification" object:nil];
//	NSLog(@"player contact with enemyBullet");
}

- (void)playerBullet:(LXYPlayerBullet *)playerBullet didContactWithEnemy:(LXYEnemy *)enemy{
	
		
	[playerBullet removeAllActions];
	[playerBullet removeAllChildren];
	[playerBullet removeFromParent];
	[enemy removeAllActions];
	[enemy removeAllChildren];
	[enemy removeFromParent];
	
	
	self.killEnemyNumber++;
	
//	NSLog(@"playerBullet contact with enemy");
}

//	临时加一个显示得分的字样，过两天就tm的重构掉，WQNMLGB
- (void)showInformation{
	
	[self removeAllChildren];
	
	// 设置关卡信息和得分信息
	NSString *stageMessage = [NSString stringWithFormat:@"你无聊地在打飞机的时间是 : %.2f秒",self.stageScore / 60.0];
	NSString *killEnemyMessage = [NSString stringWithFormat:@"你击落的敌机数量是 : %i",self.killEnemyNumber];
	
	// 设置stageMessage的字体，大小，颜色，位置
	SKLabelNode *stageLabel = [SKLabelNode labelNodeWithFontNamed:@"symbol"];
	stageLabel.text = stageMessage;
	stageLabel.fontSize = 20;
	stageLabel.fontColor = [SKColor blackColor];
	stageLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 40);
	
	// 设置scoreMessage的字体，大小，颜色，位置
	SKLabelNode *KillEnemyLabel = [SKLabelNode labelNodeWithFontNamed:@"symbol"];
	KillEnemyLabel.text = killEnemyMessage;
	KillEnemyLabel.fontSize = 20;
	KillEnemyLabel.fontColor = [SKColor blackColor];
	KillEnemyLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 20);
	
	[self addChild:stageLabel];
	[self addChild:KillEnemyLabel];
}

@end
