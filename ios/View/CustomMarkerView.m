#import "CustomMarkerView.h"

@implementation CustomMarkerView {
    NSString * _text;
}

- (instancetype)initWithText:(NSString *)text {
    self = [self initWithFrame:CGRectMake(0,0,0,0)];
    
    if (self) {
        _text = text;
        
        UIFont *font = [UIFont fontWithName:@"Roboto-Bold" size:14.0];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGSize size = [[[NSAttributedString alloc] initWithString:_text attributes:attrsDictionary] size];
        self.frame = CGRectMake(0 , 0, size.width + 12, size.height + 4);
        
        UILabel *markerText = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, size.width, size.height)];
        [markerText setText:_text];
        [markerText setTextColor:[UIColor whiteColor]];
        [markerText setBackgroundColor:[UIColor clearColor]];
        [markerText setFont:font];
        markerText.center = CGPointMake((size.width + 8) / 2, (size.height + 2) / 2);
        
        UIView* roundedView = [[UIView alloc] initWithFrame: CGRectMake(0 , 0, size.width + 8, size.height + 2)];
        roundedView.backgroundColor = [UIColor blueColor];//[UIColor colorWithRed: 0.28 green: 0.56 blue: 0.62 alpha: 1.00];
        roundedView.layer.cornerRadius = 5.0;
        roundedView.layer.masksToBounds = NO;
        [roundedView addSubview:markerText];
        
        UIView* shadowView = [[UIView alloc] initWithFrame: CGRectMake(0 , 0, size.width + 8, size.height + 2)];
        shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        shadowView.layer.shadowRadius = 1.0;
        shadowView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        shadowView.layer.shadowOpacity = 0.6;
        [shadowView addSubview: roundedView];
        
        [self addSubview:shadowView];
    }
    
    return self;
}

@end
