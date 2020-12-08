#import "CustomMarkerView.h"

@implementation CustomMarkerView {
    NSString * _text;
}

- (instancetype)initWithText:(NSString *)text {
    self = [self initWithFrame:CGRectMake(0,0,0,0)];
    if (self) {
        _text = text;
        CGSize size = [[[NSAttributedString alloc] initWithString:_text attributes:nil] size];
        self.frame = CGRectMake(0 , 0, size.width, size.height);
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [_text drawAtPoint:CGPointMake(0,0) withAttributes:nil];
}

@end
