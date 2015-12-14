#import <XCTest/XCTest.h>
#import "StressTest.h"

#include <sysexits.h>

int main(int argc, char **argv) {
	NSUInteger numIterations = 1U;
	if (*++argv) {
		//We have at least one argument. Interpret it as the number of times to run the test.
		numIterations = strtoul(*argv, /*next*/ NULL, /*radix*/ 0);
		if (numIterations == 0U) {
			fprintf(stderr, "Could not interpret number of iterations: %s\n", *argv);
			return EX_USAGE;
		}
	}

	@autoreleasepool {
		StressTest *test = [[StressTest alloc] initWithSelector:@selector(testStress)];
		SenTestRun *run = [[SenTestRun alloc] initWithTest:test];
		
		NSDate *startDate, *endDate;
		
		startDate = [NSDate date];
		[run start];
		while (numIterations--) {
			[test performTest:run];
		}
		[run stop];
		endDate = [NSDate date];
		
		BOOL success = [run hasSucceeded];
		NSLog(@"Test %@ in %f seconds", success ? @"succeeded" : @"failed", [endDate timeIntervalSinceDate:startDate]);
		
		return success ? EXIT_SUCCESS : EXIT_FAILURE;
	}
}
