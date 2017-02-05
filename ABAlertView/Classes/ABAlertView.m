//
//  ABAlertView.m
//  Pods
//
//  Created by Andrew Boryk on 2/5/17.
//
//

#import "ABAlertView.h"

@implementation ABAlertView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@synthesize alertQueue;

+ (id)sharedManager {
    static ABAlertView *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
    });
    return sharedMyManager;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        alertQueue = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (instancetype) initWithPermission: (PermissionType) type {
    self = [super init];
    
    if (self) {
        
        self.permission = type;
        self.permissionDisplayed = YES;
        
        CGFloat viewWidth = [self viewWidth] - 80.0f;
        
        NSString *title = @"";
        NSString *badge = @"";
        NSString *body = @"";
        NSString *permissionButton = @"";
        
        switch (type) {
            case PermissionLocation:
                title = @"Location Access";
                badge = @"📍";
                body = @"This will help us show you colleges nearby and cool stuff like geofilters, stickers, and trends.";
                permissionButton = @"Allow Location";
                break;
            case PermissionContacts:
                title = @"Contacts Access";
                badge = @"👥";
                body = @"Let us get the those digits so the rest of the squad can stay Tapt’in too.";
                permissionButton = @"Give Contacts Access";
                break;
            case PermissionMicrophone:
                title = @"Microphone Access";
                badge = @"🎙";
                body = @"Check 1, 2, 3... We can't hear you.\nPlease grant us access to your microphone.";
                permissionButton = @"Give Location Access";
                break;
            case PermissionCamera:
                title = @"Camera Access";
                badge = @"📷";
                body = @"To help you show off dem’ camera skills, we need permission to access your camera.";
                permissionButton = @"Give Location Access";
                break;
            case PermissionNotifications:
                title = @"Push Notifications";
                badge = @"📱";
                body = @"Stay up to date with the latest in Tapt by receiving push notifications.";
                permissionButton = @"Sure, notify me!";
                break;
                
            default:
                
                break;
        }
        
        CGFloat titleHeight = [self heightForText:title withFont:[UIFont fontWithName:@"PTSans-Bold" size:16.0f] width:viewWidth];
        CGFloat messageHeight = [self heightForText:body withFont:[UIFont fontWithName:@"PTSans-Regular" size:15.0f] width:viewWidth];
        
        CGFloat frameWidth = viewWidth;
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = CGRectMake(0, 0, frameWidth, 146.0f + titleHeight + messageHeight);
        self.center = window.center;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.0f;
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 1.0f;
        self.layer.shadowRadius = 0.5f;
        
        CGFloat titleY = 18.0f;
        if ([self notBlank:badge]) {
            self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12.0f, frameWidth - 24.0f, 48.0f)];
            self.badgeLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:40.0f];
            self.badgeLabel.textAlignment = NSTextAlignmentCenter;
            self.badgeLabel.text = badge;
            titleY = self.badgeLabel.frame.origin.y + self.badgeLabel.frame.size.height + 6.0f;
            self.frame = CGRectMake(0, 0, viewWidth, 194.0f + titleHeight + messageHeight);
            self.center = window.center;
        }
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, titleY, frameWidth - 24.0f, titleHeight)];
        self.titleLabel.font = [UIFont fontWithName:@"PTSans-Bold" size:16.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [self textColor];
        self.titleLabel.text = NSLocalizedString(title, nil);
        self.titleLabel.numberOfLines = 0;
        
        CGFloat messageY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 12.0f;
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, messageY, frameWidth - 24.0f, messageHeight)];
        self.messageLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:15.0f];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.textColor = [[self textColor] colorWithAlphaComponent:0.85f];
        self.messageLabel.text = NSLocalizedString(body, nil);
        self.messageLabel.numberOfLines = 0;
        
        CGFloat confirmY = self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + 20.0f;
        
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(24.0f, confirmY, viewWidth - 48.0f, 40.0f)];
        self.confirmButton.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:16.0f];
        
        self.confirmButton.backgroundColor = [self colorWithHexString:@"1DCBD0"];
        
        [self addShadow:self.confirmButton];
        
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmButton.layer.cornerRadius = 20.0f;
        
        [self.confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        
        [UIView setAnimationsEnabled:NO];
        [self.confirmButton setTitle:NSLocalizedString(permissionButton, nil) forState:UIControlStateNormal];
        [UIView setAnimationsEnabled:YES];
        
        CGFloat buttonY = self.confirmButton.frame.origin.y + self.confirmButton.frame.size.height + 6.0f;
        
        CGRect cancelRect = CGRectMake((viewWidth - 120.0f) / 2.0f, buttonY, 120.0f, 44.0f);
        
        self.cancelButton = [[UIButton alloc] initWithFrame:cancelRect];
        self.cancelButton.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:16.0f];
        [self.cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        
        [UIView setAnimationsEnabled:NO];
        [self.cancelButton setTitle:NSLocalizedString(@"Not Now", nil) forState:UIControlStateNormal];
        [UIView setAnimationsEnabled:YES];
        
        self.backgroundTouch = [[UIButton alloc] initWithFrame:window.bounds];
        self.backgroundTouch.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        self.backgroundTouch.alpha = 0;
        [self.backgroundTouch addTarget:self action:@selector(backgroundDismiss) forControlEvents:UIControlEventTouchUpInside];
        
        //        if (self.permission == PermissionLocation) {
        //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"Permission Location Updated" object:nil];
        //        }
        //        else if (self.permission == PermissionNotifications) {
        //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"Permission Notification Updated" object:nil];
        //        }
        
        
        [self addSubview: self.badgeLabel];
        [self addSubview: self.titleLabel];
        [self addSubview: self.messageLabel];
        [self addSubview: self.cancelButton];
        [self addSubview: self.confirmButton];
        
        self.alpha = 0;
        
    }
    
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Permission Location Updated" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Permission Notification Updated" object:nil];
}

- (instancetype) initWithTitle: (NSString *) title badge: (NSString *) badge messsage: (NSString *) message cancelButton: (NSString *) cancel confirmButton: (NSString *) confirm {
    
    self = [super init];
    
    if (self) {
        
        CGFloat viewWidth = [self viewWidth] - 80.0f;
        
        CGFloat titleHeight = [self heightForText:title withFont:[UIFont fontWithName:@"PTSans-Bold" size:16.0f] width:viewWidth];
        CGFloat messageHeight = [self heightForText:message withFont:[UIFont fontWithName:@"PTSans-Regular" size:15.0f] width:viewWidth];
        
        CGFloat frameWidth = viewWidth;
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = CGRectMake(0, 0, frameWidth, 90.0f + titleHeight + messageHeight);
        self.center = window.center;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.0f;
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 1.0f;
        self.layer.shadowRadius = 0.5f;
        
        
        
        CGFloat titleY = 18.0f;
        if ([self notBlank:badge]) {
            self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12.0f, frameWidth - 24.0f, 48.0f)];
            self.badgeLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:40.0f];
            self.badgeLabel.textAlignment = NSTextAlignmentCenter;
            self.badgeLabel.text = badge;
            titleY = self.badgeLabel.frame.origin.y + self.badgeLabel.frame.size.height + 6.0f;
            self.frame = CGRectMake(0, 0, viewWidth, 138.0f + titleHeight + messageHeight);
            self.center = window.center;
        }
        
        CGFloat frameHeight = self.frame.size.height;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, titleY, frameWidth - 24.0f, titleHeight)];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [self textColor];
        self.titleLabel.text = NSLocalizedString(title, nil);
        self.titleLabel.numberOfLines = 0;
        
        CGFloat messageY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 12.0f;
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, messageY, frameWidth - 24.0f, messageHeight)];
        self.messageLabel.font = [UIFont systemFontOfSize:15.0f];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.textColor = [[self textColor] colorWithAlphaComponent:0.85f];
        //        self.messageLabel.attributedText = [[NSAttributedString alloc] initWithData: [NSLocalizedString(message, nil) dataUsingEncoding:NSUTF16StringEncoding] options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error: nil];
        self.messageLabel.text = NSLocalizedString(message, nil);
        self.messageLabel.numberOfLines = 0;
        
        CGFloat buttonY = self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + 12.0f;
        
        if ([self notNull:confirm]) {
            CGRect cancelRect = CGRectMake(0, buttonY, frameWidth/2.0f, 48.0f);
            
            self.cancelButton = [[UIButton alloc] initWithFrame:cancelRect];
            self.cancelButton.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:16.0f];
            [self.cancelButton setTitleColor:[self warningRed] forState:UIControlStateNormal];
            [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
            
            [UIView setAnimationsEnabled:NO];
            [self.cancelButton setTitle:NSLocalizedString(cancel, nil) forState:UIControlStateNormal];
            [UIView setAnimationsEnabled:YES];
            
            
            self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(frameWidth/2.0f, buttonY, frameWidth/2.0f, 48.0f)];
            self.confirmButton.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:16.0f];
            
            [self.confirmButton setTitleColor:self.tintColor forState:UIControlStateNormal];
            
            [self.confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
            
            [UIView setAnimationsEnabled:NO];
            [self.confirmButton setTitle:NSLocalizedString(confirm, nil) forState:UIControlStateNormal];
            [UIView setAnimationsEnabled:YES];
            
            self.backgroundTouch = [[UIButton alloc] initWithFrame:window.bounds];
            self.backgroundTouch.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
            self.backgroundTouch.alpha = 0;
            [self.backgroundTouch addTarget:self action:@selector(backgroundDismiss) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            CGRect cancelRect = CGRectMake(0, buttonY, frameWidth, 48.0f);
            
            self.cancelButton = [[UIButton alloc] initWithFrame:cancelRect];
            self.cancelButton.titleLabel.font = [UIFont fontWithName:@"PTSans-Bold" size:16.0f];
            [self.cancelButton setTitleColor:self.tintColor forState:UIControlStateNormal];
            [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
            
            [UIView setAnimationsEnabled:NO];
            [self.cancelButton setTitle:NSLocalizedString(cancel, nil) forState:UIControlStateNormal];
            [UIView setAnimationsEnabled:YES];
            
            self.backgroundTouch = [[UIButton alloc] initWithFrame:window.bounds];
            self.backgroundTouch.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
            self.backgroundTouch.alpha = 0;
            [self.backgroundTouch addTarget:self action:@selector(backgroundDismiss) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview: self.badgeLabel];
        [self addSubview:self.titleLabel];
        [self addSubview: self.messageLabel];
        [self addSubview:self.cancelButton];
        
        if ([self notNull:self.confirmButton]) {
            [self addSubview: self.confirmButton];
            
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 24)];
            divider.backgroundColor = [self imageBackgroundColor];
            divider.center = CGPointMake(frameWidth / 2.0f, frameHeight - 24.0f);
            divider.userInteractionEnabled = NO;
            
            [self addSubview: divider];
        }
        
        
        self.alpha = 0;
        
    }
    
    return self;
}

- (void) confirmAction {
    
    if (self.permissionDisplayed) {
        [self requestPermission];
    }
    
    if ([self.delegate respondsToSelector:@selector(madeSelectionOnAlert:withType:)]) {
        [self.delegate madeSelectionOnAlert: self withType: AlertConfirm];
    }
    
    [self dismiss];
    
    
}

- (void) requestPermission {
    switch (self.permission) {
        case PermissionLocation:
//            [Defaults locationUpdate];
            break;
        case PermissionContacts:
            
            break;
        case PermissionMicrophone:
            
            break;
        case PermissionCamera:
            
            break;
        case PermissionNotifications:
//            [[PermissionManager sharedManager] registerPushNotifications];
            break;
            
        default:
            break;
    }
}


- (void) cancelAction {
    
    if (self.permissionDisplayed) {
        if (self.permission == PermissionLocation) {
//            [Defaults setBool:YES forKey:@"LocationRequested"];
//            [Defaults setDeferred:PermissionLocation];
        }
        else if (self.permission == PermissionNotifications) {
//            [Defaults setBool:YES forKey:@"NotificationRequested"];
//            [Defaults setBool:YES forKey:@"NotificationNotNow"];
//            [Defaults setDeferred:PermissionNotifications];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(madeSelectionOnAlert:withType:)]) {
        [self.delegate madeSelectionOnAlert: self withType: AlertCancel];
    }
    
    [self dismiss];
}

- (void) show {
    [[ABAlertView sharedManager] addAlertToQueue:self];
}

- (void) addAlertToQueue: (ABAlertView *) alert {
    if ([self notNull:alert]) {
        [alertQueue addObject:alert];
    }
    
    if (alertQueue.count == 1) {
        
        [[ABAlertView sharedManager] showNextInQueue];
    }
    
}

- (void) showNextInQueue {
    if (self.alertQueue.count) {
        if ([self notNull: [alertQueue firstObject]]) {
            
            [[ABAlertView sharedManager] presentAlert:[alertQueue firstObject]];
        }
        
        else {
            [[ABAlertView sharedManager] removeAlertFromQueue:[alertQueue firstObject]];
            [[ABAlertView sharedManager] showNextInQueue];
        }
    }
}

- (void) removeAlertFromQueue: (ABAlertView *) alert {
    if ([self notNull:alert]) {
        [alertQueue removeObject:alert];
    }
}

- (void) presentAlert: (ABAlertView *) alert {
    if ([alert.delegate respondsToSelector:@selector(alertWillShow:)]) {
        [alert.delegate alertWillShow:self];
    }
    self.mainWindow = [[UIApplication sharedApplication] keyWindow];
    [self.mainWindow makeKeyAndVisible];
    
    [self.mainWindow addSubview:alert.backgroundTouch];
    [self.mainWindow addSubview:alert];
    
    [UIView animateWithDuration:0.25f animations:^{
        alert.backgroundTouch.alpha = 1;
        alert.alpha = 1;
    } completion:^(BOOL finished) {
        if ([alert.delegate respondsToSelector:@selector(alertDidShow:)]) {
            [alert.delegate alertDidShow:self];
        }
    }];
}

- (void) backgroundDismiss {
    if (self.backgroundTouchDismissesAlert) {
        [self dismiss];
    }
}

- (void) dismiss {
    [UIView animateWithDuration:0.15f animations:^{
        self.backgroundTouch.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [[ABAlertView sharedManager] removeAlertFromQueue:self];
        
        [self removeFromSuperview];
        [self.backgroundTouch removeFromSuperview];
        [self.mainWindow removeFromSuperview];
        self.mainWindow = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Permission Location Updated" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Permission Notification Updated" object:nil];
        
        [[ABAlertView sharedManager] showNextInQueue];
    }];
}

-(CGFloat)heightForText: (NSString *)text withFont: (UIFont *) font width: (CGFloat) width
{
    // Determines height of comment cell
    
    if (![self notNull:font]) {
        font = [UIFont fontWithName:@"PTSans-Regular" size:15.0f];
    }
    
    if (![self notNull:text]) {
        text = @"";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    // this returns us the size of the text for a rect but assumes 0, 0 origin
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width-24.0f, MAXFLOAT)
                                     options:(NSStringDrawingUsesLineFragmentOrigin)
                                  attributes:attributes
                                     context:nil];
    
    return rect.size.height;
    
}

#pragma mark - Conditional Oriented
- (BOOL)notNull:(id)object {
    if ([object isEqual:[NSNull null]] || [object isKindOfClass:[NSNull class]] || object == nil) {
        return false;
    }
    else {
        return true;
    }
}

- (BOOL)isNull:(id)object {
    if ([object isEqual:[NSNull null]] || [object isKindOfClass:[NSNull class]] || object == nil) {
        return true;
    }
    else {
        return false;
    }
}

- (BOOL)notNil:(id)object {
    if (object == nil) {
        return false;
    }
    else {
        return true;
    }
}

- (BOOL)isNil:(id)object {
    if (object == nil) {
        return true;
    }
    else {
        return false;
    }
}

- (BOOL)notBlank: (NSString *) text {
    if ([self notNull:text]) {
        if (![text isEqualToString:@""]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - String Modification Oriented

- (NSString *)removeSpecialCharacters: (NSString *) text {
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    return  [[text componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
}

- (NSString *)trimWhiteSpace: (NSString *) text {
    if ([self notNull:text]) {
        text = [text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    return text;
}

- (NSString *)trimMultiSpace: (NSString *) text {
    if ([self notNull:text]) {
        while ([text containsString:@"  "]) {
            text = [text stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        }
        
        while ([text containsString:@"\n\n"]) {
            text = [text stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
        }
    }
    
    return text;
}

- (NSString *)trimWhiteAndMultiSpace: (NSString *) text {
    if ([self notNull:text]) {
        text = [self trimWhiteSpace:text];
        text = [self trimMultiSpace:text];
    }
    
    return text;
}

- (NSString *)removeSpaces: (NSString *) text {
    text = [self trimWhiteAndMultiSpace:text];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return text;
}

- (BOOL)isValidEntry: (NSString *) text {
    if ([self notNull:text]) {
        if ([self notBlank:[self removeSpaces:text]]) {
            return YES;
        }
    }
    return NO;
}

- (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [hex uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (float)viewWidth {
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    return screen.size.width;
}

- (BOOL)isLandscape {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat width = screenRect.size.width;
    CGFloat height = screenRect.size.height;
    
    if (UIDeviceOrientationIsPortrait(orientation)) {
        
        if (height < width) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        
        if (height > width) {
            return NO;
        }
        else {
            return YES;
        }
        
    }
}

- (UIColor *)textColor {
    return [self colorWithHexString:@"333333"];
}

- (UIColor *)warningRed {
    return [UIColor colorWithRed:245.0f/255.0f green:66.0f/255.0f blue:78.0f/255.0f alpha:1];
}

- (UIColor *)imageBackgroundColor {
    return [self colorWithHexString:@"EFEFF4"];
}

- (void) addShadow: (UIView *) view {
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [self colorWithHexString:@"B7B7B7"].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowOpacity = 0.5f;
    view.layer.shadowRadius = 2.0f;
}
@end
