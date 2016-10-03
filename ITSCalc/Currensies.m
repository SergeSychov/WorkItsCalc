//
//  Currensies.m
//  ITSCalc
//
//  Created by Serge Sychov on 05.01.16.
//  Copyright © 2016 Sergey Sychov. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "Currensies.h"
#import "CurrencyStore.h"

#define LOCAL_CURRENCY_KEY @"LocalCurrencyKey"
#define GEO_CURRENCY_KEY @"GeoCurrencyKey"
#define LIST_OF_CURRENSIES @"ListOfCurrensies"
#define USERS_CURENSIES_DICTIONARY @"UsesCurrensiesArray"
#define PAIRS_DICTIONARY @"PairDicitionary"
#define DATE_LAST_UPDATE @"LastUpdateDate"

#define LIST_CHANGED_NOTIFICATION @"ListChangedNotification"
#define NOT_AVAILABLE_SERVISE_NOTIFICATION @"NotAvailableServiceNotification"

@interface Currensies() <CLLocationManagerDelegate,NSURLSessionDataDelegate,NSURLSessionDelegate>

@property (nonatomic) CurrencyStore *store;

@property (nonatomic,strong) NSString* localCurrecy; //curency according uiLocal, save in archive
@property (nonatomic,strong) NSString* geoCurrency; //currency according current geo position, save in archive
@property (strong,nonatomic) NSDictionary* mainUsesCurensies; //currensies that where asking,  save in archive wtih count of using
@property (strong,nonatomic) NSDate *dateLastUpdateDictionary;//last data ubdating need for alert to user if no connection

@property (strong,nonatomic) NSString* requestString; //string for check last request
@property (strong,nonatomic) NSString* requestList;// string as list of requested pairs


//consatanst that show that list is need to be renew
@property (nonatomic) NSArray* wasAkingArray; // array was requested from recount function in calc
@property (nonatomic) BOOL flagRenewList;//shows that list must be renewed
@property (nonatomic) NSInteger renewCounter;// count that all properties is checked
@property (nonatomic) BOOL isPairsLoaded;//flag tht show loaded or not dictionary of currensies

//for locationManager
@property (strong, nonatomic) CLLocationManager *locationManager;


@property (nonatomic) BOOL allertNoConnectionWasShowed;//show is allert of lost connection was showed to user, save in archive

@end

@implementation Currensies
-(NSDictionary*)mainUsesCurensies
{
    if(!_mainUsesCurensies){
        _mainUsesCurensies = [[NSDictionary alloc]init];
    }
    return _mainUsesCurensies;
}

#pragma mark REQESTS MAKE
//for one pair
-(void) askResultForm:(NSString*)fromCur To:(NSString*)toCur
{
    //makerequest string
    NSString *requestList = [fromCur stringByAppendingString:toCur];
    self.requestList = requestList;
    NSString *requestStr = [@"http://download.finance.yahoo.com/d/quotes.csv?s=" stringByAppendingString:requestList];
    requestStr = [requestStr stringByAppendingString:@"=X&f=l1&e=.csv"];
    self.requestString = requestStr;
    
    [self requestForPairdictionary:requestStr];
}

-(NSArray*) askResultForCurrensiesArray:(NSArray*)currensies{
    NSString *requestString = @"";
    NSArray* retCurrensies = nil;
    if([[currensies firstObject] isKindOfClass:[NSArray class]] && [[[currensies firstObject] firstObject] isKindOfClass:[NSString class]] && [[[currensies firstObject] firstObject] isEqualToString:@"$"]){
        //NSLog(@"Currensies %@", currensies);
        NSMutableArray *mutCurrensies = [currensies mutableCopy];
        for(NSArray *currPairArr in currensies){
            
            //check availibility this currensies in existing array
            NSString *currFromStr = currPairArr[1];
            NSString *currToStr = currPairArr[2];
            //checking
            if([self.mainPairsdictionary objectForKey:currFromStr] && [self.mainPairsdictionary objectForKey:currToStr]){
                NSMutableArray* mutPairArray = [currPairArr mutableCopy];
                NSDictionary *insideDict = (NSDictionary*)[self.mainPairsdictionary objectForKey:currFromStr];
                
                [mutPairArray replaceObjectAtIndex:3 withObject:[insideDict valueForKey:currToStr]]; //set value from existing dictionary

                NSInteger indexOfExistPair = [currensies indexOfObject:currPairArr];//get index from nonmutable array
                //and replace in mut array
                [mutCurrensies replaceObjectAtIndex:indexOfExistPair withObject:mutPairArray];//and replace it in completed array
            } else {
                mutCurrensies = nil;
            }


            //make string for HTTP request
            requestString = [requestString stringByAppendingString:currFromStr];
            requestString = [requestString stringByAppendingString:currToStr];
            requestString = [requestString stringByAppendingString:@"=X,"];
            
        }
        requestString = [@"http://download.finance.yahoo.com/d/quotes.csv?s=" stringByAppendingString:requestString];
        requestString = [requestString substringToIndex:[requestString length]-1];
        requestString = [requestString stringByAppendingString:@"&f=l1&e=.csv"];
        self.requestString = requestString;
        
        //NSLog(@"Asking arrays %@", requestString);
       // NSLog(@"Mutcurrensies %@", mutCurrensies);
        // [self.delegate getCurrensiesArray:[mutCurrensies copy]];
        if(mutCurrensies) retCurrensies = [mutCurrensies copy];
        [self requestForPairdictionary:requestString];
        self.wasAkingArray = currensies;
    }

    return retCurrensies;
}

-(void) renewPairsDictionary
{
    [self makeStringFromPairDictionary:self.mainPairsdictionary];
}


-(void)makeStringFromPairDictionary:(NSDictionary *)mainPairsdictionary
{
    // set main pair dictionary
    _mainPairsdictionary = mainPairsdictionary;
    //make string for request from dictionary
    NSString *request = @"";
    NSArray *allKeys = [[mainPairsdictionary allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for(NSString *key in allKeys){
        NSDictionary *inSideDict = (NSDictionary*)[mainPairsdictionary objectForKey:key];
        NSArray *keysInDict = [[inSideDict allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        for(NSString *inKey in keysInDict){
            request = [request stringByAppendingString:key];
            request = [request stringByAppendingString:inKey];
            request = [request stringByAppendingString:@"=X,"];
        }
        
    }
    //string for checking responce and making right
    self.requestList = request;
    request = [@"http://download.finance.yahoo.com/d/quotes.csv?s=" stringByAppendingString:request];
    request = [request substringToIndex:[request length]-1];
    request = [request stringByAppendingString:@"&f=l1&e=.csv"];
    self.requestString = request;

    [self requestForPairdictionary:request];
    //call request function
}

-(void) requestForPairdictionary:(NSString*)rqStr
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:self delegateQueue:nil];
    NSString* exhangeRate = rqStr;
    
    NSURL *url = [NSURL URLWithString:exhangeRate];
    
    //check for coonection
    [[session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Something wrong with connection");
            //delete previos request array - no connection to server
            self.wasAkingArray = nil;
            if(!self.allertNoConnectionWasShowed){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.dateLastUpdateDictionary, @"LastUpDataDate",nil];
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:NOT_AVAILABLE_SERVISE_NOTIFICATION object:nil userInfo:userInfo]];
                    self.allertNoConnectionWasShowed=YES;
                }];
            
            }
        }
    }] resume];
    
    //download task
    [[session downloadTaskWithURL:url] resume];
}

#pragma mark REQUEST HANDLING
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    //set no of aller showing as download was sucsesed
    self.allertNoConnectionWasShowed = NO;

    NSString *str = [NSString stringWithContentsOfURL:location encoding:NSASCIIStringEncoding error:NULL];

    NSArray *separated = [str componentsSeparatedByString:@"\n"];
    //NSLog(@"separated str %@", separated);
    if(self.wasAkingArray){
        NSMutableArray *currensies = [self.wasAkingArray mutableCopy];
        if([[currensies firstObject] isKindOfClass:[NSArray class]] && [[[currensies firstObject] firstObject] isKindOfClass:[NSString class]] && [[[currensies firstObject] firstObject] isEqualToString:@"$"]){
            for(NSInteger i = 0; i < separated.count-1; i++){
                NSNumber *value = [NSNumber numberWithFloat:[(NSString*)separated[i] floatValue]];
                NSMutableArray *pair = [currensies[i] mutableCopy];
                [pair replaceObjectAtIndex:3 withObject:value];
                [currensies replaceObjectAtIndex:i withObject:pair];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.delegate getCurrensiesArray:[currensies copy]];
            });
           
            //NSLog(@"result array %@", [currensies copy]);
            self.wasAkingArray = nil;
        }
    } else if([separated count]>2){ //if getting whole list for pair dictionary
        NSMutableArray* mutCopy = [separated mutableCopy];
        [mutCopy removeObjectAtIndex:[separated count]-1];
        separated = [mutCopy copy];
        [mutCopy removeAllObjects];
        
        for(NSString *obj in separated){
            if([obj floatValue] != 0.0){
                NSNumber *numberWithString = [NSNumber numberWithFloat:[(NSString*)obj floatValue]];
                [mutCopy addObject:numberWithString];
            }
        }
        NSArray *finnishArray = [mutCopy copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fillPairsDictionary:finnishArray];
        });
    } else { //if get only one pair
        NSNumber *value = [NSNumber numberWithFloat:[str floatValue]];
        //NSLog(@"Only value: %@", value);
        NSString *firstSymbol = [self.requestList substringToIndex:3];
        
        NSRange secondSymbolRange;
        secondSymbolRange.location = 3;
        secondSymbolRange.length = 3;
        NSString *secondSymbol = [self.requestList substringWithRange:secondSymbolRange];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self setLabelWithFrom:firstSymbol To:secondSymbol AndValue:value];
            [self.delegate getCurrensiesFrom:firstSymbol To:secondSymbol AndValue:value];
            
        });
    }
}

-(void) fillPairsDictionary:(NSArray*)finnishArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *arrFromRequest= [[self.requestList componentsSeparatedByString:@","] mutableCopy];
        [arrFromRequest removeLastObject];
        NSArray *arr = [arrFromRequest copy];
        //NSLog(@"dictionary before %@",self.mainPairsdictionary);
        NSMutableDictionary *mutAllPairs = [self.mainPairsdictionary mutableCopy];
        if([arr count] == [finnishArray count]){
            for (NSInteger i= 0; i<[arr count];i++){ //for each ellement in string massive
                NSString *elemet = (NSString*)[arr objectAtIndex:i];
                NSString *firstSymbol = [elemet substringToIndex:3];
                
                NSRange secondSymbolRange;
                secondSymbolRange.location = 3;
                secondSymbolRange.length = 3;
                NSString *secondSymbol = [elemet substringWithRange:secondSymbolRange];
                
                //NSLog(@"Symbols %@ vs %@ = %@", firstSymbol,secondSymbol,[finnishArray objectAtIndex:i]);
                
                //NSMutableDictionary* mutPairDictionary = [self.mainPairsdictionary mutableCopy];
                // NSDictionary *pairs = self.mainPairsdictionary;
                
                if([[mutAllPairs allKeys] containsObject:firstSymbol]){
                    NSMutableDictionary *onePair = [[mutAllPairs objectForKey:firstSymbol] mutableCopy];
                    if([[onePair allKeys] containsObject:secondSymbol]){
                        NSNumber *value = finnishArray[i];
                        [onePair setValue:value forKey:secondSymbol];
                        [mutAllPairs setValue:[onePair copy] forKey:firstSymbol];
                    }
                    
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.mainPairsdictionary = [mutAllPairs copy];
                self.dateLastUpdateDictionary = [NSDate date];
                [[NSUserDefaults standardUserDefaults] setObject:self.dateLastUpdateDictionary forKey:DATE_LAST_UPDATE];
                
                [[NSUserDefaults standardUserDefaults] setObject:self.mainPairsdictionary forKey:PAIRS_DICTIONARY];
            });
            
            
            
            //NSLog(@"dictionary after %@",self.mainPairsdictionary);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self requestForPairdictionary:self.requestString];
            });
            
        }
        //NSLog(@"Count separated string %u", [arr count]);
        // NSLog(@"Count separated string %u", [finnishArray count]);
    });
}
#pragma mark SETUP ARRAYS
-(void) renewUsersCurrensies:(NSArray *)currArray
{
    if(([currArray count]==2) && [currArray[0] isKindOfClass:[NSString class]] && [currArray[1] isKindOfClass:[NSString class]]){
        NSString *fromCur = [currArray objectAtIndex:0];
        NSString *toCur = [currArray objectAtIndex:1];
    
        NSMutableDictionary *mutMainUsesCur = [self.mainUsesCurensies mutableCopy];
        if([mutMainUsesCur objectForKey:fromCur]){
            NSMutableArray *mutArr = [(NSArray*)[mutMainUsesCur objectForKey:fromCur] mutableCopy];
            mutArr[0] = [NSNumber numberWithInteger:[(NSNumber*)mutArr[0] integerValue]+1];
            mutArr[1] = [NSDate date];
            [mutMainUsesCur setObject:[mutArr copy] forKey:fromCur];
        
        } else {
            NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSDate date],nil];
            [mutMainUsesCur setObject:arr forKey:fromCur];
        }
    
        if([mutMainUsesCur objectForKey:toCur]){
            NSMutableArray *mutArr = [(NSArray*)[mutMainUsesCur objectForKey:toCur] mutableCopy];
            mutArr[0] = [NSNumber numberWithInteger:[(NSNumber*)mutArr[0] integerValue]+1];
            mutArr[1] = [NSDate date];
            [mutMainUsesCur setObject:[mutArr copy] forKey:toCur];
        
        } else {
            NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSDate date],nil];
            [mutMainUsesCur setObject:arr forKey:toCur];
        }
    
        self.mainUsesCurensies = [mutMainUsesCur copy];
    
        [[NSUserDefaults standardUserDefaults] setObject:self.mainUsesCurensies forKey:USERS_CURENSIES_DICTIONARY];
    }
}

-(void) makeNewCurrensiesList
{
    //IN BACKGROUND THREAD
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Test" object:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //if users dictionary
        NSDictionary* usersDict = nil;
        NSMutableArray *usersArr = nil;
        NSMutableArray *mainCurrensiesArray = [[CurrencyStore initialMainCurensies] mutableCopy];
        //delete local and geo currensies from maincurr
        if([mainCurrensiesArray containsObject:self.localCurrecy]){
            [mainCurrensiesArray removeObject:self.localCurrecy];
        }
        if(self.geoCurrency && [mainCurrensiesArray containsObject:self.geoCurrency]){
            [mainCurrensiesArray removeObject:self.geoCurrency];
        }
        NSMutableSet *othersCurrensiesSet = [[CurrencyStore initialCurrensiesSet] mutableCopy];
        //delete local and geo currensies from otherCurr
        if([othersCurrensiesSet containsObject:self.localCurrecy]){
            [othersCurrensiesSet removeObject:self.localCurrecy];
        }
        if(self.geoCurrency && [othersCurrensiesSet containsObject:self.geoCurrency]){
            [othersCurrensiesSet removeObject:self.geoCurrency];
        }
        
        //array of whole list of currensies in right order
        NSArray *wholeList = [[NSArray alloc] init];
        //array of main users currensies //main, users, geo,local
        NSArray *usersList = [[NSArray alloc] init];
        //first part users curensies form main according uses count
        NSArray *firstPart = nil;
        //second part others main currensies
        NSArray *secondPart = nil;
        //third part all currensies a;phabeticaly without users, and main
        NSArray *thirdPart = [[othersCurrensiesSet allObjects]  sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];//:[NSArray arrayWithObject:sort]];
        //four part, users currensies in backward array without main, local and geo
        NSArray *fourPart = nil;
        //then geo
        //then local
        
        if(self.mainUsesCurensies){
            NSMutableArray *firstPartMut = [[NSMutableArray alloc] init];
            //check users currensies and delete older than month
            usersDict = [self checkMainUsersCurrensies:self.mainUsesCurensies];
            //get from it array sorted by uses count
            
            usersArr = [[self sortedKeysByCountUses:usersDict] mutableCopy];
            
            for(NSString *usStr in [usersArr copy]){
                //check if usersCurencies contanin local and geo curr
                //if yes, remove it from array
                if([usStr isEqualToString:self.localCurrecy]){
                    [usersArr removeObject:usStr];
                } else if (self.geoCurrency && [usStr isEqualToString:self.geoCurrency]){
                    [usersArr removeObject:usStr];
                } else {
                    //else check if usersCurencies contain part of maincurr
                    for(NSString *mainStr in [mainCurrensiesArray copy]){
                        if([usStr isEqualToString:mainStr]){
                            [firstPartMut addObject:usStr];
                            [usersArr removeObject:usStr];
                            [mainCurrensiesArray removeObject:mainStr];
                        }
                    }
                }
                NSMutableArray* mutThirdPart = [thirdPart mutableCopy];
                if([mutThirdPart containsObject:usStr]){
                    [mutThirdPart removeObject:usStr];
                }
                thirdPart = [mutThirdPart copy];
                
            }
            firstPart = [firstPartMut copy];
            fourPart = [usersArr copy];
            
            //delte users currensies
            //first from
        }
        
        secondPart = [mainCurrensiesArray copy];
        
        if(firstPart){
            
            wholeList = [firstPart arrayByAddingObjectsFromArray:secondPart];
            wholeList = [wholeList arrayByAddingObjectsFromArray:thirdPart];
            
            usersList = [firstPart arrayByAddingObjectsFromArray:secondPart];
            
        } else {
            wholeList = [secondPart arrayByAddingObjectsFromArray:thirdPart];
            usersList = [NSArray arrayWithArray:secondPart];
            
        }
        if(fourPart){
            wholeList = [wholeList arrayByAddingObjectsFromArray:fourPart];
            usersList = [usersList arrayByAddingObjectsFromArray:fourPart];
            
        }
        if(self.geoCurrency && ![self.geoCurrency isEqualToString:self.localCurrecy]){
            wholeList = [wholeList arrayByAddingObject:self.geoCurrency];
            usersList = [usersList arrayByAddingObject:self.geoCurrency];
        }
        //NSLog(@"Local %@",self.localCurrecy);
        wholeList = [wholeList arrayByAddingObject:self.localCurrecy]; //whole list for pickers
        usersList = [usersList arrayByAddingObject:self.localCurrecy]; //list for request main and users currensies
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.listCurrensiesForPicker = wholeList;
            [self makeDictionaryForRequestFromArray:usersList];

        });
    });
    
}

//make pairs dictionary from array
//and emmidiatly send request
-(void)makeDictionaryForRequestFromArray:(NSArray*)arr
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *newPairdictionary;
        if(self.mainPairsdictionary){
            newPairdictionary = [self.mainPairsdictionary mutableCopy];
            //delete non needed object/currencies
            NSArray* keysInMainPair = [newPairdictionary allKeys];
            for(NSString* curStr in keysInMainPair){
                if(![arr containsObject:curStr]){
                    //delete whole dictionary
                    [newPairdictionary removeObjectForKey:curStr];
                    NSArray* restKeys = [newPairdictionary allKeys];
                    for(NSString *symbol in restKeys){
                        NSMutableDictionary* oneDict = [newPairdictionary objectForKey:symbol];
                        if([oneDict objectForKey:curStr]){
                            [oneDict removeObjectForKey:curStr];
                            [newPairdictionary setObject:[oneDict copy] forKey:symbol];
                        }
                    }
                }
            }
            
            for(NSString *str in arr){
                //key, object MSDictionary [key,value]
                NSSet *keysSet = [[NSSet alloc] initWithArray:[newPairdictionary allKeys]];
                if(![keysSet containsObject:str]){
                    //new dictionary for new currensy
                    NSMutableDictionary* newCurrdict = [[NSMutableDictionary alloc] init];
                    for(NSString* key in keysSet){
                        //for each keys add key/value[0] for new currency
                        NSMutableDictionary *currDict = [(NSDictionary*)[newPairdictionary objectForKey:key] mutableCopy];
                        [currDict setObject:[NSNumber numberWithFloat:0] forKey:str];
                        [newPairdictionary setObject:[currDict copy] forKey:key];
                        
                        //add to new currency dictionary 0 value for each keys
                        [newCurrdict setObject:[NSNumber numberWithFloat:0] forKey:key];
                    }
                    //add dictionary for new currency to all
                    [newPairdictionary setObject:newCurrdict forKey:str];
                }
            }
            
            
        } else {
            newPairdictionary = [[NSMutableDictionary alloc] init];
            for(NSString *str in arr){
                NSMutableDictionary* newCurrDict = [[NSMutableDictionary alloc] init];
                for(NSString *nextStr in arr){
                    if(![nextStr isEqualToString:str]){
                        [newCurrDict setObject:[NSNumber numberWithFloat:0.] forKey:nextStr];
                    }
                }
                [newPairdictionary setObject:[newCurrDict copy] forKey:str];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mainPairsdictionary = [newPairdictionary copy]; //ready ampty dictionary for request
            [[NSUserDefaults standardUserDefaults] setValue:self.mainPairsdictionary forKey:PAIRS_DICTIONARY];
            [self makeStringFromPairDictionary:[newPairdictionary copy]];
            
        });
    });
}

-(void)setRenewCounter:(NSInteger)renewCounter
{
    _renewCounter = renewCounter;

    if(self.flagRenewList && (self.renewCounter == 4)){
        //make new currensies list and make request
        [self makeNewCurrensiesList];
    }
}

-(void) setListCurrensiesForPicker:(NSArray *)listCurrensiesForPicker
{
    _listCurrensiesForPicker = listCurrensiesForPicker;
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:listCurrensiesForPicker] forKey:LIST_OF_CURRENSIES];
    [[NSNotificationCenter defaultCenter] postNotificationName:LIST_CHANGED_NOTIFICATION object:nil];
}

-(void) setPropertiesFromUserdefault
{
    //set renew counter to 0
    self.renewCounter = 0;
    self.flagRenewList = NO;
    
    //load currencies from user default
    if([[NSUserDefaults standardUserDefaults] objectForKey:LIST_OF_CURRENSIES]){
        NSData *listData = [[NSUserDefaults standardUserDefaults] objectForKey:LIST_OF_CURRENSIES];
        self.listCurrensiesForPicker = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
        self.renewCounter++;
    }else{
        self.listCurrensiesForPicker = [CurrencyStore initialCurrensiesList];
        self.renewCounter++;
        self.flagRenewList = YES;
    }
    //renewCounter = 1
    
    //get and check local cureency
    NSString *locCurrency = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
    NSLog(@"Loc cur %@", locCurrency);

    if([[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_CURRENCY_KEY]){
        NSString *locCurFromUserDefault = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_CURRENCY_KEY];
        if(locCurFromUserDefault != locCurrency){
            self.flagRenewList = YES;
        }
        self.renewCounter++;
    } else {
        self.renewCounter++;
    }
    self.localCurrecy = locCurrency;
    //renewCounter = 2
    
    //get geo currency
    if([[NSUserDefaults standardUserDefaults] objectForKey:GEO_CURRENCY_KEY]){
        self.geoCurrency =[[NSUserDefaults standardUserDefaults] objectForKey:GEO_CURRENCY_KEY];
        
    } else {
        self.geoCurrency = nil;
        self.flagRenewList = YES;
        self.renewCounter++;

    }
    //launch location request
    [self.locationManager requestLocation];
    
    //get users currensies list
    if([[NSUserDefaults standardUserDefaults] objectForKey:USERS_CURENSIES_DICTIONARY]){
        NSDictionary *listData =(NSDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:USERS_CURENSIES_DICTIONARY];
        self.mainUsesCurensies = listData;
        self.renewCounter++;
    } else {
        self.flagRenewList = YES;
        self.mainUsesCurensies = nil;
        self.renewCounter++;
    }
    //renewCounter = 4
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:PAIRS_DICTIONARY]){
        NSDictionary *listData =(NSDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:PAIRS_DICTIONARY];
        self.mainPairsdictionary = listData;
        self.isPairsLoaded = YES;
    } else {
        self.isPairsLoaded = NO;
        //START SPINER
        //NOT ALLOW CONVERT BUTTON
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:DATE_LAST_UPDATE]){
        self.dateLastUpdateDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_LAST_UPDATE];
    } else {
        self.dateLastUpdateDictionary = nil;
    }
}
#pragma mark SET AND CHECK FUNCTION
//check users currensies dictionary and delete older than one month
-(NSDictionary*) checkMainUsersCurrensies:(NSDictionary*)currDict
{
    NSMutableDictionary* mutCurr = [currDict mutableCopy];
    NSArray *keys = [currDict allKeys];
    for( NSString* key in keys){
        NSArray *value = [currDict objectForKey:key];
        if([(NSDate*)value[1] timeIntervalSinceNow] > 2592000){ //older than month
            [mutCurr removeObjectForKey:key];
        }
    }
    _mainUsesCurensies = [mutCurr copy];
    [[NSUserDefaults standardUserDefaults] setObject:_mainUsesCurensies forKey:USERS_CURENSIES_DICTIONARY];
    return _mainUsesCurensies;
}

//return sorted keys from users currensies dictionary
-(NSArray*)sortedKeysByCountUses:(NSDictionary*)usersDict
{
    
    NSArray *myArray = [usersDict keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1[0] integerValue] > [obj2[0] integerValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1[0] integerValue] < [obj2[0] integerValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    return myArray;
}

#pragma mark LOCATION MANAGER
-(void)askForLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager setDelegate: self];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             //получаем текущий код страны и запускаем получение кода валюты через вспомогательную функцию
             //get current country code and check it throuh help function
             
             NSString *currentCountryCode = [[NSString alloc]initWithString:placemark.ISOcountryCode];
             //get currensy Code from Country code
             NSString *currentCurrencyCode = [self currencyCodeFromCountryCode:currentCountryCode];
             
             //setup GeoCurrensy and check for changes
             [self chekGeoCurrency:currentCurrencyCode];
         }
         else
         {
             //NSLog(@"Geocode failed with error %@", error);
             self.renewCounter++;
             
         }
     }];
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    //NSLog(@"Error %@",error);
}

#pragma mark CHECK CHANGES FUNCTIONS
-(void) setLocalCurrecy:(NSString *)localCurrecy
{
    _localCurrecy = localCurrecy;
    [[NSUserDefaults standardUserDefaults] setObject:_localCurrecy forKey:LOCAL_CURRENCY_KEY];
}
-(void) chekGeoCurrency:(NSString*)geoCur
{
    if(self.geoCurrency != geoCur){
        _geoCurrency = geoCur;
        self.flagRenewList = YES;
    }
    [[NSUserDefaults standardUserDefaults] setObject:_geoCurrency forKey:GEO_CURRENCY_KEY];
    self.renewCounter++;
}

#pragma mark HELP FUNCTIONS
//get currency code from country code
-(NSString*) currencyCodeFromCountryCode:(NSString*)countryCode
{
    NSSet *XCDcaribianSet = [[NSSet alloc] initWithObjects:@"AG", @"DM", @"GD", @"MS", @"KN", @"LC", @"VC", @"AI", nil];
    NSSet *EURSet = [[NSSet alloc] initWithObjects:@"AT", @"BE", @"DE", @"IE", @"ES", @"IT", @"LU", @"NL",
                     @"PT", @"FI", @"FR", @"GR", @"SI", @"SY", @"MT", @"SK",
                     @"EE", @"LV", @"LT", @"AD", @"VA", @"MC", @"SM", @"PM",
                     @"XK", @"BL", @"MF", @"ME", nil];
    NSSet *XAFZoneSet = [[NSSet alloc] initWithObjects:@"CM", @"CF", @"GA", @"TD", @"GQ", @"CG", nil];
    NSSet *XPVZoneSet = [[NSSet alloc] initWithObjects:@"NC", @"PF", @"WF", nil];
    NSString* setCountryCode = countryCode;
    if([XCDcaribianSet containsObject:countryCode]){
        setCountryCode = @"XC";
    } else if([EURSet containsObject:countryCode]){
        setCountryCode = @"EU";
    } else if([XAFZoneSet containsObject:countryCode]){
        setCountryCode = @"XA";
    } else if([XPVZoneSet containsObject:countryCode]){
        setCountryCode = @"XP";
    }
    
    //NSLog(@"counttyStr %@",countryCode);
    NSString *returnString = @"NON";
    for (NSString* str in [CurrencyStore initialCurrensiesList]){
        NSString* st = [str substringToIndex:2];
        //NSLog(@"str: %@, st: %@",str,st);
        if([st isEqualToString:setCountryCode]){
            returnString = str;
            break;
        }
    }
    return returnString;
}
#pragma mark SETUP
-(void) setup
{
    //ask for location manager
    [self askForLocationManager];
    
    //set main arrais from uses defaults
    [self setPropertiesFromUserdefault];
    self.wasAkingArray = nil;
}
-(id) init
{
    self = [super init];
    if(self) [self setup];
    return self;
}
-(void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}
@end
