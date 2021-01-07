#ifndef YamapMarkerView_h
#define YamapMarkerView_h
#import <React/RCTComponent.h>
#import <YandexMapKit/YMKPolygonMapObject.h>
#import <YandexMapKit/YMKPoint.h>
#import "CustomMarkerView.h"

@class YamapMarkerView;

@protocol YamapMarkerViewDelegate <NSObject>
-(void) markerPressed:(NSString*) pointId
                point:(YMKPoint*) point
           markerView:(YamapMarkerView*) markerView;

@end

@class RCTBridge;

@interface YamapMarkerView: UIView<YMKMapObjectTapListener, RCTComponent>
@property (assign) id <YamapMarkerViewDelegate> delegate;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;

-(instancetype)initWithCustomMarker:(NSString*) text
                           andPoint:(YMKPoint*) point
                         andPointId:(NSString*) pointId
                           andState:(BOOL) state;

-(void) activate;
-(void) deactivate;

// props
-(void) setZIndex:(NSNumber*) _zIndex;
-(void) setScale:(NSNumber*) _scale;
-(void) setSource:(NSString*) _source;
-(void) setPoint:(YMKPoint*) _points;
-(void) setPointId:(NSString*) _pointId;
-(void) setAnchor:(NSValue*) _anchor;

-(YMKPoint*) getPoint;
-(YMKPlacemarkMapObject*) getMapObject;
-(void) setMapObject:(YMKPlacemarkMapObject*) mapObject;
-(void) insertSubview:(UIView *)view;

@end

#endif /* YamapMarkerView_h */
