//
//  ViewController.m
//  MPS
//
//  Created by Jasneet singh Narula on 2016-02-14.
//  Copyright © 2016 Jasneet. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize coord;
@synthesize coordinate;
@synthesize Mapview;
@synthesize myRootRef;
@synthesize postId;
@synthesize routeRef;
@synthesize flyRef;
@synthesize retrievedData;
@synthesize flyDate;
@synthesize routeInfo;
@synthesize locationArray;
@synthesize refArray;
@synthesize route1;
@synthesize myRoute;
@synthesize routeLine;
@synthesize routeLineView;
@synthesize flyData;
@synthesize selectRouteButton;

extern BOOL shuffleFlag = false;
extern BOOL flyFlag = true;

extern int counter = 0;
//extern NSString *windspeed;
//extern NSString *precipitation;


- (IBAction)clearRoute:(id)sender {
    
    [Mapview removeAnnotations:Mapview.annotations];
    [Mapview removeOverlays:Mapview.overlays];
    [_addPin setEnabled:true];
    [selectRouteButton setEnabled:false];
    [myRoute removeAllObjects];
    
    CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
    
    [myRoute addObject:currentLoc];
    flyTimeLbl.text = @"NONE";
    canFlyLbl.text = @"NONE";
    canFlyLbl.textColor = [UIColor blackColor];

}




- (IBAction)mapType:(id)sender
{
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        self.Mapview.mapType = MKMapTypeStandard;
    }
    if (self.segmentControl.selectedSegmentIndex == 1)
    {
        self.Mapview.mapType = MKMapTypeSatellite;
    }
    if (self.segmentControl.selectedSegmentIndex == 2)
    {
        self.Mapview.mapType = MKMapTypeHybrid;
    }
}



-(IBAction)addingAnnotations:(id)sender
{
    
    
//    if(flyFlag==true)
//    {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPin:)];
    [recognizer setNumberOfTapsRequired:1];
    [Mapview addGestureRecognizer:recognizer];
//    }
    
//    else
  //  {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
//                                                        message:@"Current weather condition is not suitbale to fly"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    
 //   }
}


- (void)addPin:(UITapGestureRecognizer*)recognizer
{
    [selectRouteButton setEnabled:true];
    
    shuffleFlag=false;
    
    CGPoint tappedPoint = [recognizer locationInView:Mapview];
    NSLog(@"Tapped At : %@",NSStringFromCGPoint(tappedPoint));
    coordinate= [Mapview convertPoint:tappedPoint toCoordinateFromView:Mapview];
    NSLog(@"lat  %f",coordinate.latitude);
    NSLog(@"long %f",coordinate.longitude);
    NSNumber *latitudeAnn = [[NSNumber alloc] initWithDouble: coordinate.latitude];
    NSNumber *longitudeAnn = [[NSNumber alloc] initWithDouble: coordinate.longitude];
   CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [myRoute addObject:loc];
    
    NSLog(@"%@",myRoute);
    
    
  
    
    
    
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = coordinate;
    
    [Mapview selectAnnotation:myAnnotation animated:YES];
    [self.Mapview addAnnotation:myAnnotation];
    myAnnotation.title=@"Hello";
    recognizer.enabled = NO;
    [locationArray addObject:myAnnotation];
    
   
}


- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id) annotation
{
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.Mapview dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    if (pin == nil)
    {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"myPin"] ;
        pin.canShowCallout = YES;
    } else
    {
        pin.annotation = annotation;
    }
    pin.animatesDrop = YES;
    pin.draggable = YES;
    pin.selected = YES;
    [pin.layer setZPosition:999];
    return pin;
}



- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        
        
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        
        coordinate = droppedAt;
        
        NSNumber *updatedLatitudeAnn = [[NSNumber alloc] initWithDouble: coordinate.latitude];
        NSNumber *updatedLongitudeAnn = [[NSNumber alloc] initWithDouble: coordinate.longitude];
        
      
    }
}





-(IBAction)selectRoute:(id)sender
{
    if (flyFlag == true) {
        canFlyLbl.text = @"YES";
        [canFlyLbl setTextColor:[UIColor colorWithRed:(0/255.f) green:(100/255.f) blue:(0/255.f) alpha:1.0f]];
        
    }
    else
    {
        canFlyLbl.text = @"NO";
        canFlyLbl.textColor = [UIColor redColor];
    }

    
    [_addPin setEnabled:false];
    [retrievedData removeAllObjects];
    counter = 0;
    
    if(shuffleFlag == false)
    {
    int pinCount = myRoute.count;
    CLLocationCoordinate2D coordinateArray[pinCount];
    
    for (int x = 1; x < pinCount - 2; x++) {
            int randInt = (arc4random() % ((pinCount - 1) - x)) + x;
            [myRoute exchangeObjectAtIndex:x withObjectAtIndex:randInt];
            
            
        }
        
        
    for(int i=0; i<pinCount; i++)
    {
    CLLocation *loc = myRoute[i];
    
    
    coordinateArray[i] = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude);
    
    }
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pinCount];
   [self.Mapview setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
    
    [self.Mapview addOverlay:self.routeLine];
        shuffleFlag = true;
    }
    
    else if(shuffleFlag == true)
    {
        [Mapview setCenterCoordinate:Mapview.region.center animated:NO];
        [Mapview removeOverlays:Mapview.overlays];
        
        int pinCount = myRoute.count;
        CLLocationCoordinate2D coordinateArray[pinCount];
        
       
        
        for (int x = 1; x < pinCount - 2; x++) {
            int randInt = (arc4random() % ((pinCount - 1) - x)) + x;
            [myRoute exchangeObjectAtIndex:x withObjectAtIndex:randInt];
            
            
        }
        
        for(int i=0; i<pinCount; i++)
        {
            CLLocation *loc = myRoute[i];
            
            
            coordinateArray[i] = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude);
            
            
            
        }
        
        
        self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pinCount];
        [self.Mapview setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
        
        [self.Mapview addOverlay:self.routeLine];
        
           }
    
    for(int i = 0; i < [myRoute count]; i++)
        {
            //[retrievedData removeAllObjects];
            counter++;
            
            CLLocation *locat = [myRoute objectAtIndex:i];
            
            NSString *pinCounter = [[NSString alloc] initWithFormat:@"%d", counter];
            
            NSString *latitudeLoc = [NSString stringWithFormat:@"%f",
                                   locat.coordinate.latitude];
            NSString *longitudeLoc = [NSString stringWithFormat:@"%f",
                                     locat.coordinate.longitude];
            NSMutableDictionary *locdata = [[NSMutableDictionary alloc] init];
            
            [locdata setObject:latitudeLoc forKey:@"latitudeLoc"];
            
            [locdata setObject:longitudeLoc forKey:@"longitudeLoc"];
            
            [retrievedData setObject:locdata forKey:pinCounter];
            
        }
    
    NSString *strCurrentDate;
    NSString *strNewDate;
    NSDate *date = [NSDate date];
    NSDateFormatter *df =[[NSDateFormatter alloc]init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    strCurrentDate = [df stringFromDate:date];
    NSLog(@"Current Date and Time: %@",strCurrentDate);
    int hoursToAdd = arc4random_uniform(12);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hoursToAdd];
    NSDate *newDate= [calendar dateByAddingComponents:components toDate:date options:0];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    strNewDate = [df stringFromDate:newDate];
    NSLog(@"New Date and Time: %@",strNewDate);
    flyData = [strNewDate componentsSeparatedByString:@", "];
    NSLog(@"%@",flyData[0]);
    NSLog(@"%@",flyData[1]);
    NSLog(@"%@",flyData[2]);
    
    [flyDate setObject:flyData[0] forKey:@"FlyDay"];
    [flyDate setObject:flyData[1] forKey:@"FlyYear"];
    [flyDate setObject:flyData[2] forKey:@"FlyTime"];
    
    routeRef = [myRootRef childByAppendingPath: @"routes"];
    flyRef = [myRootRef childByAppendingPath: @"flyTime"];
    
    NSDictionary *users = @{
                            @"routes": retrievedData,
                            @"flyTime": flyData
                            };
    [routeRef setValue: users];
    
    //[routeRef setValue:retrievedData];
    //[routeRef setValue:flyDate];
   flyTimeLbl.text = strNewDate;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                                  message:@"The Route Info Is sent to Quadcopter Cloud"
                                                                                 delegate:self
                                                                        cancelButtonTitle:@"OK"
                                                                        otherButtonTitles:nil];
                                  [alert show];


}



- (MKOverlayRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 6;
        
        return renderer;
    }
    
    return nil;
}

- (void)viewDidLoad
{

    shuffleFlag = false;
    myRoute = [[NSMutableArray alloc] initWithObjects:nil];
  
    refArray = [[NSMutableArray alloc] init];
    locationArray = [[NSMutableArray alloc] init];
    retrievedData = [[NSMutableDictionary alloc] initWithObjectsAndKeys: nil];
    self.Mapview.delegate = self;
    locationManager = [[CLLocationManager alloc]init];
    
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    
    [locationManager startUpdatingLocation];
    
    Mapview.showsUserLocation = YES;
    
    locationManager.delegate = self;
    
    CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
    
    [myRoute addObject:currentLoc];
    
    NSLog(@" current log %@",currentLoc);
    
    NSNumber *myDoubleLatitude = [NSNumber numberWithDouble:locationManager.location.coordinate.latitude];
    NSString *latitude = [myDoubleLatitude stringValue];
    
    NSNumber *myDoubleLongitude = [NSNumber numberWithDouble:locationManager.location.coordinate.longitude];
    NSString *longitude = [myDoubleLongitude stringValue];
    
    
    
    
    myRootRef = [[Firebase alloc] initWithUrl:@"https://mpsurd.firebaseio.com/"];
    
    //weather info for fly
    NSString *urlString =   [NSString stringWithFormat:@"https://api.forecast.io/forecast/937f4a6446c0793c36c30bdda7efd97a/%@,%@",latitude,longitude];
    NSLog(@"%@,%@", latitude,longitude);
    //NSError  *error;
    //NSURLResponse *response;
    //NSData *data = [NSURLConnection sendsy]
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response;
    NSError *error;
    //send it synchronous
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // check for an error. If there is a network error, you should handle it here.
    if(!error)
    {
        NSData *json = [NSJSONSerialization JSONObjectWithData:responseData options:nil error:&error];
        NSData *currentData = [json valueForKey:@"currently"];
        int windspeed =[[currentData valueForKey:@"windSpeed"] intValue];
        float precipitation = [[currentData valueForKey:@"precipIntensity"] floatValue];
        NSLog(@"windspeed is %d km/h",windspeed);
        NSLog(@"Precipitation is %fpercent ",precipitation);
        if(windspeed>15 || precipitation>80)
        {
            flyFlag= false;
            NSLog(@"%d cannot fly",flyFlag);
        }
        NSLog(@"%d can fly",flyFlag);
        
        
        
        if (flyFlag == true) {
            canFlyLbl.text = @"YES";
            [canFlyLbl setTextColor:[UIColor colorWithRed:(0/255.f) green:(100/255.f) blue:(0/255.f) alpha:1.0f]];
            
        }
        else
        {
            canFlyLbl.text = @"NO";
            canFlyLbl.textColor = [UIColor redColor];
        }

        
        
    }
    
    
    
   // NSLog(@"%@",responseData);
    NSLog(@"latitude%f",locationManager.location.coordinate.latitude);
    NSLog(@" longitude%f",locationManager.location.coordinate.longitude);
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
