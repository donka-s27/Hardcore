//
//  JSProgress.h
//  PhotoSauce
//
//  Created by ZhXingli on 1/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface JSProgress : NSObject<MBProgressHUDDelegate>
{
    MBProgressHUD*      m_hud;
    BOOL                m_bWaiting;
    UIViewController*             m_parent;
}
-(void)SetProgress:(float)percent;
-(void)SetType;

-(id)initWithParentView:(UIViewController*)parent title:(NSString*)text;
-(void)ShowProgress;
-(void)ShowProgress:(SEL)method;
-(void)HideProgress;
@end
