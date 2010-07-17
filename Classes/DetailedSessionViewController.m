//
//  DetailedSessionViewController.m
//  incogito
//
//  Created by Markuz Lindgren on 15.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "DetailedSessionViewController.h"
#import "JZSession.h"
#import "JZSessionBio.h"
#import "SectionSessionHandler.h"
#import "IncogitoAppDelegate.h"

@implementation DetailedSessionViewController

@synthesize session;
@synthesize sessionTitle;
@synthesize sessionLocation;
@synthesize details;
@synthesize level;
@synthesize levelImage;
@synthesize handler;

- (void)viewDidLoad {
	checkboxSelected = 0;
	
    [super viewDidLoad];
	
	handler = [appDelegate sectionSessionHandler];
	
	NSDateFormatter *startFormatter = [[NSDateFormatter alloc] init];
	[startFormatter setDateFormat:@"hh:mm"];
	NSDateFormatter *endFormatter = [[NSDateFormatter alloc] init];
	[endFormatter setDateFormat:@"hh:mm"];
	
	[sessionTitle setText:session.title];
	[sessionLocation setText:[NSString stringWithFormat:@"%@ - %@ in room %@",
							  [startFormatter stringFromDate:[session startDate]],
							  [endFormatter stringFromDate:[session endDate]],
							  [session room]]];

	[details loadHTMLString:[self buildPage:[session detail] withSpeakerInfo:[self buildSpeakersSection:[session speakers]]] baseURL:nil];
	
	[level setText:[session level]];
	
	[levelImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [session level]]]];
	
	[startFormatter release];
	[endFormatter release];
	
	if ([session userSession]) {
		checkboxSelected = 1;
		[checkboxButton setSelected:YES];
	}
}

- (IBAction)checkboxButton:(id)sender{
	if (checkboxSelected == 0){
		[checkboxButton setSelected:YES];
		checkboxSelected = 1;
		[handler setFavouriteForSession:session withBoolean:YES];
	} else {
		[checkboxButton setSelected:NO];
		checkboxSelected = 0;
		[handler setFavouriteForSession:session withBoolean:NO];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

- (void) closeModalViewController:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (NSString *)buildSpeakersSection:(NSSet *)speakers {
	NSMutableString *result = [[NSMutableString alloc] init];
	
	for (JZSessionBio *speaker in speakers) {
		NSString *speakerLine = [NSString stringWithFormat:@"<h3>%@</h3>%@", [speaker name], [speaker bio]];
		
		[result appendString:speakerLine];
	}
	
	NSString *speakerSection = [NSString stringWithString:result];
	
	[result release];
	
	return speakerSection;
}

- (NSString *)buildPage:(NSString *)content withSpeakerInfo:(NSString *)speakerInfo {
	NSString *page = [NSString stringWithFormat:@""
					  "<html>"
					  "<head>"
					  "<style type=\"text/css\">"
					  "body {"
					  "  font-family: Helvetica;"
					  "}"
					  "div.paragraph {"
					  "  font-size: 13px;"
					  "  margin-bottom: 8px;"
					  "}"
					  "li {"
					  "  font-size: 13px;"
					  "}"
					  "h2 {"
					  "  font-size: 15px;"
					  "  font-weight: bold;"
					  "}"
					  "h3 {"
					  "  font-size: 15px;"
					  "  font-weight: normal;"
					  "}"
					  "</style>"
					  "</head>"
					  "<body>"
					  "%@"
					  "<h2>Speakers</h2>"
					  "%@"
					  "</body>"
					  "</html>",
					  content,
					  speakerInfo];
	
	return page;
}

@end
