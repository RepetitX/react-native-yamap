#import <React/RCTComponent.h>
#import <React/UIView+React.h>

#import <MapKit/MapKit.h>
#import <YandexMapKit/YMKMapKitFactory.h>
#import <YandexMapKit/YMKMapView.h>
#import <YandexMapKit/YMKBoundingBox.h>
#import <YandexMapKit/YMKCameraPosition.h>
#import <YandexMapKit/YMKCircle.h>
#import <YandexMapKit/YMKPolyline.h>
#import <YandexMapKit/YMKPolylineMapObject.h>
#import <YandexMapKit/YMKMap.h>
#import <YandexMapKit/YMKMapObjectCollection.h>
#import <YandexMapKit/YMKGeoObjectCollection.h>
#import <YandexMapKit/YMKSubpolylineHelper.h>
#import <YandexMapKit/YMKPlacemarkMapObject.h>
#import <YandexMapKitTransport/YMKMasstransitSession.h>
#import <YandexMapKitTransport/YMKMasstransitRouter.h>
#import <YandexMapKitTransport/YMKPedestrianRouter.h>
#import <YandexMapKitTransport/YMKMasstransitRouteStop.h>
#import <YandexMapKitTransport/YMKMasstransitOptions.h>
#import <YandexMapKitTransport/YMKMasstransitSection.h>
#import <YandexMapKitTransport/YMKMasstransitSectionMetadata.h>
#import <YandexMapKitTransport/YMKMasstransitTransport.h>
#import <YandexMapKitTransport/YMKMasstransitWeight.h>
#import <YandexMapKitTransport/YMKTimeOptions.h>

#ifndef MAX
#import <NSObjCRuntime.h>
#endif

#import "YamapMarkerView.h"
#import "CustomMarkerView.h"

#define ANDROID_COLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0  alpha:((c>>24)&0xFF)/255.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation YamapMarkerView {
    YMKPoint* _point;
    NSString* _pointId;
    NSString* _text;
    
    YMKPlacemarkMapObject* mapObject;
    NSNumber* zIndex;
    NSNumber* scale;
    NSString* source;
    NSString* lastSource;
    NSValue* anchor;
    NSMutableArray<UIView*>* _reactSubviews;
    UIView* _childView;
}

@synthesize delegate;

-(instancetype)init {
    self = [super init];
    zIndex =  [[NSNumber alloc] initWithInt:1];
    scale =  [[NSNumber alloc] initWithInt:1];
    _reactSubviews = [[NSMutableArray alloc] init];
    source = @"";
    lastSource = @"";
    return self;
}

-(instancetype)initWithCustomMarker:(NSString*) text
                           andPoint:(YMKPoint*) point
                         andPointId:(NSString*) pointId
                           andState:(BOOL) state
{
    self = [self init];

    _text = text;
    _pointId = pointId;
    
    [self setPoint:point];
    [self insertCustomMarkerWithText:text andState:state];

    return self;
}

-(CustomMarkerView*) createCustomMarkerWithText:(NSString*) text
                                      andState:(BOOL) state
{
    CustomMarkerView *customMarker;

    if (state) {
        customMarker = [[CustomMarkerView alloc] initWithText:text andColor:[UIColor redColor]];
    } else {
        customMarker = [[CustomMarkerView alloc] initWithText:text];
    }
    
    return customMarker;
}

-(void) insertCustomMarkerWithText:(NSString*) text
                          andState:(BOOL) state
{
    CustomMarkerView* customMarker = [self createCustomMarkerWithText:text andState:state];
    [self removeReactSubview:_childView];
    [self insertReactSubview:customMarker atIndex:0];
    [self didUpdateReactSubviews];
    //[mapObject setZIndex: state ? 2 : 1];
    zIndex = state ? [NSNumber numberWithInt:2] : [NSNumber numberWithInt:1];
}

-(void) updateMarker {
    if (mapObject != nil) {
        [mapObject setGeometry:_point];
        [mapObject setZIndex:[zIndex floatValue]];
        YMKIconStyle* iconStyle = [[YMKIconStyle alloc] init];
        [iconStyle setScale:scale];
        if (anchor) {
          [iconStyle setAnchor:anchor];
        }
		if ([_reactSubviews count] == 0) {
			if (![source isEqual:@""]) {
				if (![source isEqual:lastSource]) {
					[mapObject setIconWithImage:[self resolveUIImage:source]];
					lastSource = source;
				}
			}
		}
        [mapObject setIconStyleWithStyle:iconStyle];
	}
}

-(void) setScale:(NSNumber*) _scale {
    scale = _scale;
    [self updateMarker];
}
-(void) setZIndex:(NSNumber*) _zIndex {
    zIndex = _zIndex;
    [self updateMarker];
}

-(void) setPoint:(YMKPoint*) point {
    _point = point;
    [self updateMarker];
}

-(UIImage*) resolveUIImage:(NSString*) uri {
    UIImage *icon;
    if ([uri rangeOfString:@"http://"].location == NSNotFound && [uri rangeOfString:@"https://"].location == NSNotFound) {
        if ([uri rangeOfString:@"file://"].location != NSNotFound){
            NSString *file = [uri substringFromIndex:8];
            icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:file]]];
        } else {
            icon = [UIImage imageNamed:uri];
        }
    } else {
        icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:uri]]];
    }
    return icon;
}

-(void) setSource:(NSString*) _source {
    source = _source;
    [self updateMarker];
}

-(void) setMapObject:(YMKPlacemarkMapObject *)_mapObject {
    mapObject = _mapObject;
    [mapObject addTapListenerWithTapListener:self];
    [self updateMarker];
}

// object tap listener
- (BOOL)onMapObjectTapWithMapObject:(nonnull YMKMapObject *)_mapObject point:(nonnull YMKPoint *)point {
    if (self.onPress) {
        self.onPress(@{});
    } else {
        [self.delegate markerPressed:_pointId point:point markerView:self];
    }
    
    return YES;
}

-(void) activate {
    [self insertCustomMarkerWithText:_text andState:YES];
}

-(void) deactivate {
    [self insertCustomMarkerWithText:_text andState:NO];
}

-(void) setPointId:(NSString*) pointId {
    _pointId = pointId;
}

-(YMKPoint*) getPoint {
    return _point;
}

-(void) setAnchor:(NSValue*)_anchor {
    anchor = _anchor;
}

-(YMKPlacemarkMapObject*) getMapObject {
    return mapObject;
}

-(void) setChildView {
    if ([_reactSubviews count] > 0) {
        _childView = [_reactSubviews objectAtIndex:0];
        if (_childView != nil) {
            [_childView setOpaque:false];
            YRTViewProvider* v = [[YRTViewProvider alloc] initWithUIView:_childView];
            if (v != nil) {
				if (mapObject.isValid) {
					[mapObject setViewWithView:v];
                    [self updateMarker];
				}
            }
        }
    } else {
        _childView = nil;
    }
}

-(void) didUpdateReactSubviews {
    // todo: Если вызывать сразу то frame имеет размеры 0. В идеале делать подписку на событие
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self setChildView];
    });
}

- (void)insertReactSubview:(UIView*) subview atIndex:(NSInteger)atIndex {
    [_reactSubviews insertObject:subview atIndex: atIndex];
    [super insertReactSubview:subview atIndex:atIndex];
}

- (void)removeReactSubview:(UIView*) subview {
    [_reactSubviews removeObject:subview];
    [super removeReactSubview: subview];
}

@synthesize reactTag;

@end
