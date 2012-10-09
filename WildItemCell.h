//
//  WildItemCell.h
//  Wild Books Practice
//
//  Created by Annie Jo Cain on 10/1/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WildItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *daysUntilDueLabel;


@end
