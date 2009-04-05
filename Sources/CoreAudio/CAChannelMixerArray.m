/*
 
 [The "BSD licence"]
 Copyright (c) 2003-2006 Arizona Software
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 1. Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 3. The name of the author may not be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
														   NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
														   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "CAChannelMixerArray.h"

@implementation CAChannelMixerArray

- (id)init
{
	if(self = [super init]) {
		mArray = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[mArray release];
	[super dealloc];
}

- (id)mutableCopyWithZone:(NSZone*)zone
{
	CAChannelMixerArray *copy = [[CAChannelMixerArray allocWithZone:zone] init];
	copy->mArray = [mArray mutableCopyWithZone:zone];
	return copy;
}

- (void)setChannelCount:(int)count
{
	int i;
	for(i=0; i<count; i++) {
		if([mArray count] == i)
			[mArray addObject:[NSNumber numberWithInt:i<2?i:NONE_VALUE]];
	}
	
	while([mArray count]>count)
		[mArray removeLastObject];
}

- (NSNumber*)channelAtIndex:(int)index
{
	return [mArray objectAtIndex:index];
}

- (void)setChannel:(NSNumber*)number atIndex:(int)index
{
	[mArray replaceObjectAtIndex:index withObject:number];
}

- (unsigned short*)optimizedBufferArray
{
	// Optimized array in the form: [c1][c2]...[cn]
	// where ci = NONE_VALUE: no channel, ≠ NONE_VALUE: channel number
	unsigned count = [mArray count];
	unsigned short* buffer = malloc(count*sizeof(unsigned short));
	int i;
	for(i=0; i<count; i++) {
		unsigned short v = [[mArray objectAtIndex:i] intValue];						
		memcpy(buffer+i, &v, sizeof(unsigned short));
	}
	return buffer;
}

@end
