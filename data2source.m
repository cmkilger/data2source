#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	if (argc < 3 || argc > 4) {
		printf("Usage: data2source <path/to/data> <path/to/output> [functionName]\n");
		return -1;
	}
	
	// Import data
	NSString * path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:1];
	NSData * data = [NSData dataWithContentsOfFile:path];
	NSUInteger length = [data length];
	UInt8 * bytes = (UInt8 *) [data bytes];
	
	// Output source paths
	NSString * outputHeaderPath = [[[[NSProcessInfo processInfo] arguments] objectAtIndex:2] stringByAppendingPathExtension:@"h"];
	NSString * outputSourcePath = [[[[NSProcessInfo processInfo] arguments] objectAtIndex:2] stringByAppendingPathExtension:@"m"];
	
	// Function name
	NSString * functionName = @"data";
	if (argc == 4)
		functionName = [[[NSProcessInfo processInfo] arguments] objectAtIndex:3];
	
	// Comment header section
	NSMutableString * intro = [NSMutableString string];
	[intro appendFormat:@"// This file was auto-generated by data2source\n"];
	[intro appendFormat:@"// \n"];
	[intro appendFormat:@"// Original file named %@\n", [path lastPathComponent]];
	
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[intro appendFormat:@"// Created on %@", [dateFormatter stringFromDate:[NSDate date]]];
	
	// Create header
	NSMutableString * header = [NSMutableString string];
	[header appendFormat:@"%@\n\n", intro];
	
	[header appendFormat:@"#import <Foundation/Foundation.h>\n\n"];
	[header appendFormat:@"NSData * %@();\n\n", functionName];
	
	// Save header
	[header writeToFile:outputHeaderPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	// Create source
	NSMutableString * source = [NSMutableString string];
	[source appendFormat:@"%@\n\n", intro];
	
	[source appendFormat:@"#import \"%@\"\n\n", [outputHeaderPath lastPathComponent]];
	[source appendFormat:@"NSUInteger length = %d;\n", length];
	[source appendFormat:@"UInt8 data[] = {"];
	
	int x = 0;
	for (int index = 0; index < length; index++) {
		if (x == 0)
			[source appendFormat:@"\n\t"];
		[source appendFormat:@"%3d, ", bytes[index]];
		x++;
		x %= 20;
	}
	
	[source appendFormat:@"\n};\n\n"];
	
	[source appendFormat:@"NSData * %@() {\n", functionName];
	[source appendFormat:@"\treturn [NSData dataWithBytesNoCopy:data length:length freeWhenDone:NO];\n"];
	[source appendFormat:@"}\n"];
	
	// Save source
	[source writeToFile:outputSourcePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	
    [pool drain];
    return 0;
}
