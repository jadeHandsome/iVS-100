/*
 * IJKFFCodec.h
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//@protocol IJKFFCoder;

@interface IJKFFCoder : NSObject

- (int)initcode;
- (void)uninitcode;

- (int)encoder:(uint8_t*) src srclen:(int) len dest:(uint8_t*) dst;

@end
