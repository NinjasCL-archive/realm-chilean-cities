//
//  CVZPAdministrativeArea.h
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


#import "CVZPLocalityModel.h"

#import <Realm/Realm.h>

/*!
 * This class holds the administrative area ( ex V Región)
 * name, id and its localities
 */
@interface CVZPAdministrativeAreaModel : RLMObject

/*!
 * Name for the administrative area
 */
@property (nonatomic) NSString * name;

/*!
 * Number for the administrative area
 */
@property (nonatomic) NSInteger number;

/*!
 * The localities inside the administrative area
 */
@property (nonatomic) RLMArray <CVZPLocalityModel> * localities;


#pragma mark - Public Abstract Methods

/*!
 *    Creates a new Administrative Area using data from the Json file
 *
 *    @param data extracted from json file in main bundle
 *
 *    @return a new instance of CVZPAdministrativeArea
 */
+ (CVZPAdministrativeAreaModel *) administrativeAreaWithData: (NSDictionary *) data;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<CVZPAdministrativeAreaModel>
RLM_ARRAY_TYPE(CVZPAdministrativeAreaModel)
