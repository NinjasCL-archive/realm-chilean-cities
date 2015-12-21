// CVZPAdministrativeAreasList.m
// 
// Copyright (c) 2015 Ninjas.cl
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


#import "CVZPAdministrativeAreaModel.h"
#import "CVZPLocationProtocol.h"

#import "CVZPAdministrativeAreasListController.h"

#import "CVZPSubAdministrativeAreaListController.h"


#import <Realm/Realm.h>

@interface CVZPAdministrativeAreasListController()

@property (nonatomic) RLMNotificationToken * notification;

@property (nonatomic) CVZPAdministrativeAreaModel * selectedAdministrativeArea;

@end

@implementation CVZPAdministrativeAreasListController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupRealmNotification];
    [self reloadData];
}

#pragma mark - Helpers

- (void) setupRealmNotification {
    
    // Set realm notification block
    // See https://realm.io/docs/objc/latest/#notifications
    
    __weak typeof(self) weakSelf = self;
    
    self.notification = [RLMRealm.defaultRealm
                         addNotificationBlock:^(NSString *note,
                                                RLMRealm *realm) {
                             
                             [weakSelf reloadData];
                         }];
    
}

- (void) reloadData {
    
    [self.tableView reloadData];
}

- (NSArray *) items {
    
    return (NSArray *) [CVZPAdministrativeAreaModel allObjects];
}

#pragma mark - Table View

#pragma mark Data Source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
    static NSString * cellIdentifier = @"AdministrativeAreaCell";
    
    UITableViewCell * cell = [tableView
                              dequeueReusableCellWithIdentifier:cellIdentifier
                              forIndexPath:indexPath];
    
    id<CVZPLocationProtocol> area = self.items[indexPath.row];
    
    cell.textLabel.text = area.name;
    
    return cell;
}

#pragma mark Delegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    CVZPAdministrativeAreaModel * area = self.items[indexPath.row];
    
    self.selectedAdministrativeArea = area;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"showSubAdministrativeAreas" sender:self];
}

#pragma mark - Segue

- (void) prepareForSegue: (UIStoryboardSegue *) segue
                  sender:(id)sender {
    
    CVZPSubAdministrativeAreaListController * controller  = (CVZPSubAdministrativeAreaListController *) segue.destinationViewController;
    
    controller.administrativeArea = self.selectedAdministrativeArea;
    
}
@end
