//
//  ViewController.m
//  OpenEars-sample
//
//  Created by yutatotz on 6/18/15.
//  Copyright (c) 2015 yutatotz. All rights reserved.
//

#import "ViewController.h"
#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OEPocketsphinxController.h>
#import <OpenEars/OEAcousticModel.h>


@interface ViewController ()

@end

@implementation ViewController

NSString *lmPath = nil;
NSString *dicPath = nil;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.openEarsEventsObserver = [[OEEventsObserver alloc] init];
    [self.openEarsEventsObserver setDelegate:self];
 
    /*
    // from shu-san's code
    NSArray *words = @[
                       @"SUNDAY",
                       @"MONDAY",
                       @"TUESDAY",
                       @"WEDNESDAY",
                       @"THURSDAY",
                       @"FRIDAY",
                       @"SATURDAY",
                       @"QUIDNUNC",
                       @"CHANGE MODEL",
                       ];
    self.amPath = [OEAcousticModel pathToModel:@"AcousticModelEnglish"];
    OELanguageModelGenerator *generator = [[OELanguageModelGenerator alloc] init];
    NSError *error = [generator generateLanguageModelFromArray:words
                                                withFilesNamed:@"OpenEarsDynamicGrammar"
                                        forAcousticModelAtPath:self.amPath];
    
    if (error.code != noErr) {
        
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    else {
        
        NSDictionary *languageGeneratorResults = [error userInfo];
        
        self.lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        self.dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
    }*/
    
    OELanguageModelGenerator *lmGenerator = [[OELanguageModelGenerator alloc] init];
    
    NSArray *words = [NSArray arrayWithObjects:@"WORD", @"STATEMENT", @"OTHER WORD", @"A PHRASE", nil];
    NSString *name = @"NameIWantForMyLanguageModelFiles";
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]]; // Change "AcousticModelEnglish" to "AcousticModelSpanish" to create a Spanish language model instead of an English one.
    
    if(err == nil) {
        
        lmPath = [lmGenerator pathToSuccessfullyGeneratedLanguageModelWithRequestedName:@"NameIWantForMyLanguageModelFiles"];
        dicPath = [lmGenerator pathToSuccessfullyGeneratedDictionaryWithRequestedName:@"NameIWantForMyLanguageModelFiles"];
        
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    
    // from tutorial
    [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
    [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF: NO]; // start listening
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startListening {
    
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
}

- (void) pocketsphinxDidStartListening {
    NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
    NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
    NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
    NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
    NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
    NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
    NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening setup wasn't successful and returned the failure reason: %@", reasonForFailure);
}

- (void) pocketSphinxContinuousTeardownDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening teardown wasn't successful and returned the failure reason: %@", reasonForFailure);
}

- (void) testRecognitionCompleted {
    NSLog(@"A test file that was submitted for recognition is now complete.");
}


@end
