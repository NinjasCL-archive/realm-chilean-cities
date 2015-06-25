// CVZPRealmHelper.m
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

#import "CVZPRealmHelper.h"

#import <Realm/Realm.h>

@implementation CVZPRealmHelper

+ (void) setupRealmWithSchemaVersion: (NSInteger) schemaVersion
           deletingPreviousDatabase: (BOOL) deleteDatabase {

    if (deleteDatabase) {
        
        [CVZPRealmHelper deleteDefaultRealmFromFilesystem];
    }
    
    
    // Notice setSchemaVersion is set to 1, this is always set manually. It must be
    // higher than the previous version (oldSchemaVersion) or an RLMException is thrown
    // see https://realm.io/docs/objc/latest/#migrations
    
    [RLMRealm setSchemaVersion:schemaVersion
                forRealmAtPath:[RLMRealm defaultRealmPath]
            withMigrationBlock:^(RLMMigration *migration, uint64_t oldSchemaVersion) {
                
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            }];
    
    // now that we have called `setSchemaVersion:withMigrationBlock:`, opening an outdated
    // Realm will automatically perform the migration and opening the Realm will succeed
    [RLMRealm defaultRealm];
    
}

+ (void) deleteDefaultRealmFromFilesystem {
    
    [[NSFileManager defaultManager]
     removeItemAtPath:[RLMRealm defaultRealmPath]
     error:nil];
}

@end
