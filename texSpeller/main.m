//
//  main.m
//
//
//

#import <Foundation/Foundation.h>
#import "TeXSpellerDelegate.h"


int main(int argc, const char * argv[])
{
    @autoreleasepool {

        NSString *appName = [[[NSBundle mainBundle] infoDictionary]  objectForKey:(NSString *)kCFBundleNameKey];

        TeXSpellerDelegate *spellServer = [[TeXSpellerDelegate alloc] init];

        NSSpellServer *aServer = [[NSSpellServer alloc] init];
        [aServer registerLanguage:@"English" byVendor:appName];
        [aServer setDelegate:spellServer];
        [aServer run];
    }
    return 0;
}
