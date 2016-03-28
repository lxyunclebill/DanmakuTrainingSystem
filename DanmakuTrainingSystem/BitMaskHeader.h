//
//  BitMaskHeader.h
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-5-31.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#ifndef DanmakuTrainingSystem_BitMaskHeader_h
#define DanmakuTrainingSystem_BitMaskHeader_h

//	位掩码，处理碰撞检测用
static const uint32_t playerCategory		= 0x00000001;
static const uint32_t playerBulletCategory	= 0x00000010;
static const uint32_t enemyCategory			= 0x00000100;
static const uint32_t enemyBulletCategory	= 0x00001000;
static const uint32_t sceneEdgeCategory		= 0x10000000;

#endif
