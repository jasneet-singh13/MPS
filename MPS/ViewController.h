//
//  ViewController.h
//  MPS
//
//  Created by Jasneet singh Narula on 2016-02-14.
//  Copyright © 2016 Jasneet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Firebase/Firebase.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController : UIViewController<MKMapViewDelegate,MKAnnotation,CLLocationManagerDelegate,MKOverlay,UIAlertViewDelegate>

{
    CLLocationManager *locationManager;
    CLLocation *location;
    
    IBOutlet UILabel *flyTimeLbl;
    IBOutlet UILabel *canFlyLbl;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addPin;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clear;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *selectRouteButton;
@property (retain, nonatomic)Firebase *myRootRef;
@property (retain, nonatomic)Firebase *routeRef;
@property (retain, nonatomic)Firebase *flyRef;
@property (retain, nonatomic)Firebase *route1;
@property (retain, nonatomic)NSString* postId;
@property (weak, nonatomic) IBOutlet MKMapView *Mapview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (assign, nonatomic) CLLocationCoordinate2D coord;
@property (retain, nonatomic)NSMutableDictionary *retrievedData;
@property (retain, nonatomic)NSMutableDictionary *flyDate;
@property (retain, nonatomic)NSMutableDictionary *routeInfo;

@property (retain, nonatomic)NSMutableArray *locationArray;
@property (retain, nonatomic)NSArray *flyData;
@property (retain, nonatomic)NSMutableArray *refArray;
@property (retain, nonatomic) NSMutableArray *myRoute;

@property (nonatomic, retain) MKPolylineView *routeLineView;
@property (nonatomic, retain) MKPolyline *routeLine;

@end

