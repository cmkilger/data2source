#import <Foundation/Foundation.h>
#import "ImageData.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSData * data = dataForImage();
	NSString *path = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingPathComponent:@"happy_birthday.jpg"];
	[data writeToFile:path atomically:YES];
	
	printf("An image should now open in Preview.\n");
	
	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:[NSArray arrayWithObjects:@"-a", @"Preview", [NSString stringWithFormat:@"%@", path], nil]];
	
    [pool drain];
    return 0;
}
