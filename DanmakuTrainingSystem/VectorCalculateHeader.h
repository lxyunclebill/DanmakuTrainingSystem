//
//  VectorCalculateHeader.h
//  DanmakuTrainingSystem
//
//  Created by 林 轩宇 on 14-6-7.
//  Copyright (c) 2014年 林 轩宇. All rights reserved.
//

#ifndef DanmakuTrainingSystem_VectorCalculateHeader_h
#define DanmakuTrainingSystem_VectorCalculateHeader_h

//	向量运算
static inline CGPoint pointAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint pointSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint pointMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

// 计算向量长度
static inline float pointLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

// 返回一个方向与当前向量相同的单位向量
static inline CGPoint pointNormalize(CGPoint a) {
    float length = pointLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

#endif
