#ifndef YamapMarkerView_h
#define YamapMarkerView_h
#import <React/RCTComponent.h>
#import <YandexMapKit/YMKPolygonMapObject.h>
#import <YandexMapKit/YMKPoint.h>

@protocol YamapMarkerViewDelegate <NSObject>
-(void) markerPressed:(YMKMapObject*) mapObject;   //method from ClassA
@end

@class RCTBridge;

@interface YamapMarkerView: UIView<YMKMapObjectTapListener, RCTComponent>
@property (assign) id <YamapMarkerViewDelegate> delegate;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;

// props
-(void) setZIndex:(NSNumber*) _zIndex;
-(void) setScale:(NSNumber*) _scale;
-(void) setSource:(NSString*) _source;
-(void) setPoint:(YMKPoint*) _points;
-(void) setAnchor:(NSValue*) _anchor;

-(YMKPoint*) getPoint;
-(YMKPlacemarkMapObject*) getMapObject;
-(void) setMapObject:(YMKPlacemarkMapObject*) mapObject;
-(void) insertSubview:(UIView *)view;

@end

#endif /* YamapMarkerView_h */
