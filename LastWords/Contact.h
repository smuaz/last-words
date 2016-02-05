//
//  Contact.h
//  LastWords
//
//  Created by Syed Muaz on 8/25/14.
//  Copyright (c) 2014 team41. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject {
    NSString *name;
    NSString *email;
    PFFile *photo;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) PFFile *photo;
@end
