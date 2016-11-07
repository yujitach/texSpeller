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
- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language wordCount:(NSInteger *)wordCount countOnly:(BOOL)countOnly{
    NSLog(@"%@",stringToCheck);
    return [checker checkSpellingOfString:stringToCheck startingAt:0 language:language wrap:NO inSpellDocumentWithTag:0 wordCount:wordCount];
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
