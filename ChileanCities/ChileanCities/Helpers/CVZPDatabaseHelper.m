// CVZPDatabaseHelper.m
//
// Copyright (c) 2015 Cervezapps
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CVZPDatabaseHelper.h"

#import "CVZPAdministrativeAreaModel.h"
#import "CVZPLocalityModel.h"

#import "CVZPJsonHelper.h"

#import <Realm/Realm.h>

@implementation CVZPDatabaseHelper

+ (void) loadAdministrativeAreasAndLocalities {

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([CVZPAdministrativeAreaModel allObjects].count <= 0) {
                
                [CVZPDatabaseHelper createAdministrativeAreasAndLocalities];
            }
            
        }); 
    });
}

/*!
 * Fills the database with cities and regions
 */
+ (void) createAdministrativeAreasAndLocalities {
    

    dispatch_async(dispatch_get_main_queue(), ^{

        
        // TODO: Refactor the JSON file to represent
        // the correct spellings of administrative areas
        // and localities
        // comuna/ciudad = locality
        // region = administrativeArea
        // provincia = subAdministrativeArea
        // See https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLPlacemark_class/
        
        NSDictionary * data = [CVZPJsonHelper
                               readJSONFromMainBundleWithFileName:@"chilean-locations"];
        
        NSArray * administrativeAreas = data[@"regions"];
        NSArray * localities;
        
        RLMRealm * realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        
        for (NSDictionary * administrativeAreaData in administrativeAreas) {
            
            localities = administrativeAreaData[@"cities"];
            
            CVZPAdministrativeAreaModel * administrativeArea = [CVZPAdministrativeAreaModel
                                                              administrativeAreaWithData:
                                                              administrativeAreaData];
            
            NSMutableDictionary * mutableLocalityData;
            
            for (NSDictionary * localityData in localities) {
                
                mutableLocalityData = [localityData mutableCopy];
                
                mutableLocalityData[@"administrativeAreaNumber"] = @(administrativeArea.number);
                
                CVZPLocalityModel * locality = [CVZPLocalityModel
                                                localityWithData:mutableLocalityData];
                
                [administrativeArea.localities addObject:locality];
            }
            
            [realm addObject:administrativeArea];
            
        }
        
        [realm commitWriteTransaction];
        
        [realm refresh];
        
    });
   
}

@end
