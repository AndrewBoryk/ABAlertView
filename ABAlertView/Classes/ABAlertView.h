//
//  ABAlertView.h
//  Pods
//
//  Created by Andrew Boryk on 2/5/17.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
//#import "Enums.h"

/// Type of Post
typedef NS_ENUM(NSInteger, AlertSelectionType) {
    AlertCancel,
    AlertConfirm,
    AlertOther,
};

typedef NS_ENUM(NSInteger, PermissionType) {
    PermissionLocation,
    PermissionContacts,
    PermissionMicrophone,
    PermissionCamera,
    PermissionNotifications,
    PermissionNone,
};

@protocol ABAlertViewDelegate;

@interface ABAlertView : UIView {
    /// Queue which holds alerts
    NSMutableArray *alertQueue;
}

/// Shared Manager for TAlertView
+ (id)sharedManager;

/// Add alert to queue
- (void) addAlertToQueue: (ABAlertView *) alert;

/// Displays the next alert in queue
- (void) showNextInQueue;

/// Removes alert from queue
- (void) removeAlertFromQueue: (ABAlertView *) alert;

@property (weak, nonatomic) id <ABAlertViewDelegate> delegate;

/// Queue which holds alerts
@property (retain, nonatomic) NSMutableArray *alertQueue;

/// Link to be displayed when interacting with alert
@property (retain, nonatomic) NSString *link;

/// Action which should be associated with this alert
@property (retain, nonatomic) NSString *action;

/// Window which displays alert view
@property (strong, nonatomic) UIWindow *mainWindow;

/// Button which shows that background is grayed out, and allows dismissal when touch up inside
@property (strong, nonatomic) UIButton *backgroundTouch;

/// Label which displays emoji
@property (strong, nonatomic) UILabel *badgeLabel;

/// Label which displays title
@property (strong, nonatomic) UILabel *titleLabel;

/// Label which displays message
@property (strong, nonatomic) UILabel *messageLabel;

/// Button which shows cancel/dismiss option
@property (strong, nonatomic) UIButton *cancelButton;

/// Button which shows confirm option
@property (strong, nonatomic) UIButton *confirmButton;

/// Toggles on and off for background touch to dismiss alert
@property BOOL backgroundTouchDismissesAlert;

/// Permission displayed
@property BOOL permissionDisplayed;

/// Type of permission displayed
@property PermissionType permission;

/// Initialize a Permissions alert
- (instancetype) initWithPermission: (PermissionType) type;

/// Initializes alert view
- (instancetype) initWithTitle: (NSString *) title badge: (NSString *) badge messsage: (NSString *) message cancelButton: (NSString *) cancel confirmButton: (NSString *) confirm;

/// Shows alert view
- (void) show;

/// Dismisses alert view
- (void) dismiss;

@end

@protocol ABAlertViewDelegate <NSObject>

@optional

/// Returns to the user the alert view and the selection choice
- (void) madeSelectionOnAlert:(ABAlertView *)alertView withType:(AlertSelectionType)type;

/// A selection was made on a permission alert
- (void) permissionSelectedOnAlert:(ABAlertView *)alertView withType:(AlertSelectionType)type;

/// Alert will show in view
- (void) alertWillShow:(ABAlertView *)alert;

/// Alert did show in view
- (void) alertDidShow:(ABAlertView *)alert;

@end
