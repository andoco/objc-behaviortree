/*
 *  BPGeometry.h
 *
 *  Created by Jon Olson on 11/30/09.
 *  Copyright 2009 Ballistic Pigeon, LLC. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

extern CGPoint CGPointScale(CGPoint A, double b);
extern CGPoint CGPointAdd(CGPoint a, CGPoint b);
extern CGPoint CGPointSubtract(CGPoint a, CGPoint b);
extern double CGPointCross(CGPoint a, CGPoint b);
extern double CGPointDot(CGPoint a, CGPoint b);
extern double CGPointMagnitude(CGPoint pt);
extern CGPoint CGPointNormalize(CGPoint pt);

extern BOOL BPLineSegmentsIntersect(CGPoint a1, CGPoint a2, CGPoint b1, CGPoint b2);
