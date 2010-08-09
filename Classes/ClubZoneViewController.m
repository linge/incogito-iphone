//
//  ClubZoneViewController.m
//  incogito
//
//  Created by Chris Searle on 06.08.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "ClubZoneViewController.h"

@implementation ClubZoneViewController

@synthesize mapView;
@synthesize locationToggle;

- (void)viewDidLoad {
	followingLocation = NO;
	
    [super viewDidLoad];
	
	[[locationToggle layer] setCornerRadius:8.0f];
	[[locationToggle layer] setMasksToBounds:YES];
	
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.912958,10.754421}
																	  andName:@"JavaZone"
															 andEntertainment:@"Oslo Spektrum"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.91291,10.761501}
																	  andName:@"Gloria Flames"
															 andEntertainment:@"Piano Bar"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.912149,10.765695}
																	  andName:@"Ivars Kro"
															 andEntertainment:@"Cover Band"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.913128,10.760233}
																	  andName:@"Dattera til Hagen"
															 andEntertainment:@"Stand-Up"] autorelease]];
	[mapView addAnnotation:[[[ClubzoneMapAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){59.913696,10.756906}
																	  andName:@"Cafe Con Bar"
															 andEntertainment:@"DJ"] autorelease]];
	
	mapView.showsUserLocation = YES;
	
	[self.mapView.userLocation addObserver:self  
								forKeyPath:@"location"  
								   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
								   context:NULL];
	
	[self goToDefaultLocationAndZoom];
}

-(void)observeValueForKeyPath:(NSString *)keyPath  
                     ofObject:(id)object  
                       change:(NSDictionary *)change  
                      context:(void *)context {  
	
    if (followingLocation) {
		[mapView setCenterCoordinate:[[[self.mapView userLocation] location] coordinate] animated:YES];
    } else {
		[self goToDefaultLocationAndZoom];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation {
	if ([annotation class] == MKUserLocation.class) {
        return nil;
    }
	
	MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mv dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
	
	if(pinView == nil) {
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
		
		pinView.pinColor = MKPinAnnotationColorPurple;
		pinView.animatesDrop = YES;
		pinView.canShowCallout = YES;
	} else {
		pinView.annotation = annotation;
	}
	
	return pinView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction)locationButton:(id)sender {
	followingLocation = !followingLocation;
	
	[locationToggle setSelected:followingLocation];
	
	if (followingLocation == NO) {
		[locationToggle setBackgroundColor:[UIColor clearColor]];
		[self goToDefaultLocationAndZoom];
	} else {
		[locationToggle setBackgroundColor:[UIColor blueColor]];
		mapView.region = MKCoordinateRegionMakeWithDistance([[[self.mapView userLocation] location] coordinate], 750, 750);
	}
}

- (void) goToDefaultLocationAndZoom {
	CLLocationCoordinate2D coordinate;
	
	coordinate.latitude = 59.912337;
	coordinate.longitude = 10.760036;
	
	[mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 750, 750) animated:YES];
}

@end
