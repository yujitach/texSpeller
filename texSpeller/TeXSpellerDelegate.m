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
    NSCharacterSet*alpha;
}
- (TeXSpellerDelegate*)init
{
    checker=[NSSpellChecker sharedSpellChecker];
    checker.language=@"English";
    alpha=[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    return self;
}

-(NSString*)stringStrippedOfTeXFromString:(NSString*)string
{
    NSMutableString*result=[NSMutableString string];
    NSScanner*scanner=[NSScanner scannerWithString:string];
    scanner.charactersToBeSkipped=nil;
    for(;;){
        NSString*bit=@"";
        if([scanner scanUpToString:@"\\" intoString:&bit]){
            [result appendString:bit];
        }
        if([scanner isAtEnd])
            break;
        // at this point the next character is guaranteed to be a backslash
        [scanner scanString:@"\\" intoString:nil];
        [result appendString:@"\\"];
        if([scanner scanCharactersFromSet:alpha intoString:&bit]){
            for(int i=0;i<[bit length];i++){
                [result appendString:@"#"];
            }
            if([scanner isAtEnd])
                break;
            if([@[@"cite",@"label",@"ref",@"eqref",@"begin",@"end"] containsObject:bit]){
                if([scanner scanString:@"{" intoString:nil]){
                    [result appendString:@"{"];
                }
                if([scanner isAtEnd])
                    break;
                NSString*zot=@"";
                if([scanner scanUpToString:@"}" intoString:&zot]){
                    for(int i=0;i<[zot length];i++){
                        [result appendString:@"#"];
                    }
                }
                if([scanner isAtEnd])
                    break;
            }
        }
        if([scanner isAtEnd])
            break;
    }
    return result;
}

#pragma mark - old api
- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language wordCount:(NSInteger *)wordCount countOnly:(BOOL)countOnly{
    NSLog(@"%@",stringToCheck);
    NSString*transformed=[self stringStrippedOfTeXFromString:stringToCheck];
    NSLog(@"%@",transformed);
    return [checker checkSpellingOfString:transformed startingAt:0 language:language wrap:NO inSpellDocumentWithTag:0 wordCount:wordCount];
}

- (nullable NSArray<NSString *> *)spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word inLanguage:(NSString *)language{
    NSArray<NSString*>* guesses=[checker guessesForWordRange:NSMakeRange(0,[word length]) inString:word language:language inSpellDocumentWithTag:0];
    return guesses;
}

- (void)spellServer:(NSSpellServer *)sender didForgetWord:(NSString *)word inLanguage:(NSString *)language
{
    [checker unlearnWord:word];
}
- (void)spellServer:(NSSpellServer *)sender didLearnWord:(nonnull NSString *)word inLanguage:(nonnull NSString *)language
{
    [checker learnWord:word];
}


@end
