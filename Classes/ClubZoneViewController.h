//
//  ClubZoneViewController.h
//  incogito
//
//  Created by Chris Searle on 06.08.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ClubzoneMapAnnotation.h"

@interface ClubZoneViewController : UIViewController <MKMapViewDelegate>{
	IBOutlet MKMapView *mapView;
	IBOutlet UIButton *locationToggle;
	BOOL followingLocation;
}

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UIButton *locationToggle;


- (IBAction)locationButton:(id)sender;
- (void) goToDefaultLocationAndZoom;

@end
