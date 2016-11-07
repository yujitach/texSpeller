//
//  AspellServer.m
//  macAspell
//
//  Created by Yuji on 2016/11/07.
//  Copyright © 2016年 Yuji Tachikawa. All rights reserved.
//
@import AppKit;
#import "TeXSpellerDelegate.h"


@implementation TeXSpellerDelegate
{
    NSSpellChecker*checker;
}
- (TeXSpellerDelegate*)init
{
    checker=[NSSpellChecker sharedSpellChecker];
    checker.language=@"English";
    return self;
}

#pragma mark - old api
#if 0
- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language wordCount:(NSInteger *)wordCount countOnly:(BOOL)countOnly{
    
    NSLog(@"Old api - find mispelled word in string: %@", stringToCheck);
    
    *wordCount = -1;
    return [stringToCheck rangeOfString:@"badword"];
}

- (nullable NSArray<NSString *> *)spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word inLanguage:(NSString *)language{
    
    NSLog(@"Old api - suggest guesses for word: %@", word);
    
    if ([word isEqualToString:@"badword"]) {
        return @[@"goodword"];
    }
    
    return nil;
}


#endif

#pragma mark - new api
-(NSString *) languageFromOthrography:(NSOrthography *)orthrography
{
    if(orthrography && orthrography.allLanguages.firstObject) {
        return orthrography.allLanguages.firstObject;
    } else {
        return [[NSLocale currentLocale] valueForKey:NSLocaleLanguageCode];
    }
}

-(nullable NSArray<NSTextCheckingResult *> *)spellServer:(NSSpellServer *)sender checkString:(NSString *)stringToCheck offset:(NSUInteger)offset types:(NSTextCheckingTypes)checkingTypes options:(nullable NSDictionary<NSString *, id> *)options orthography:(nullable NSOrthography *)orthography wordCount:(NSInteger *)wordCount {
    NSOrthography*o;
    NSArray<NSTextCheckingResult *> * results=[checker checkString:stringToCheck range:NSMakeRange(offset,[stringToCheck length]-offset) types:checkingTypes options:options inSpellDocumentWithTag:0 orthography:&o wordCount:wordCount];
    return results;
#if 0
    
    BOOL checkSpelling = (checkingTypes & NSTextCheckingTypeSpelling) > 0;
    BOOL provideCorrections = (checkingTypes & NSTextCheckingTypeCorrection) > 0;
    
    NSString *language = [self languageFromOthrography:orthography];
    NSLog(@"New api method, language: %@, for %@, offset: %lu, spelling: %d, corrections: %d", language, stringToCheck, (unsigned long)offset, checkSpelling, provideCorrections);
    
    *wordCount = -1;
    NSMutableArray<NSTextCheckingResult *> *results = [NSMutableArray new];
    
    NSRange range = NSMakeRange(0, stringToCheck.length);
    NSStringCompareOptions compareOptions = NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch;
    
    //check all strings
    while (true) {
        NSRange foundRange = [stringToCheck rangeOfString:@"badword" options:compareOptions range:range];
        if (foundRange.location != NSNotFound) {
            range.location = foundRange.location + foundRange.length;
            range.length = stringToCheck.length - range.location;
            
            NSRange rangeWithOffset = NSMakeRange(foundRange.location + offset, foundRange.length);
            
            [results addObject:[NSTextCheckingResult spellCheckingResultWithRange:rangeWithOffset]];
            
            //you can remove this line, if you are also providing method 'suggestGuessesForWord:...'
            [results addObject:[NSTextCheckingResult correctionCheckingResultWithRange:rangeWithOffset replacementString:@"goodword"]];
        }else {
            break;
        }
    }
    
    return results;
#endif
}

@end
