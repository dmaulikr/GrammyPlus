//
//  ViewController.m
//  GrammyPlus
//
//  Created by 李灿 on 2017/4/16.
//  Copyright © 2017年 reverse. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "NXOAuth2.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actLogin:(id)sender {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Instagram"];
    
}
- (IBAction)actLogout:(id)sender {
}
- (IBAction)actRefresh:(id)sender {
    NSArray *isgAccounts=[[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"Instagram"];
    if([isgAccounts count]==0){
        NSLog(@"Fail");
        return;
    }
    NXOAuth2Account *acct=isgAccounts[0];
    NSString *token=acct.accessToken.accessToken;
    NSString *urlStr=[@"https://api.instagram.com/v1/users/self/media/recent/?access_token=" stringByAppendingString:token];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLSession *session=[NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //Check for network error
        if(error){
            NSLog(@"Error:Couldn't finish rquest :%@",error);
            return;
        }
        
        //Check for http error
        NSError *parseErr;
        NSHTTPURLResponse *httpResp =(NSHTTPURLResponse *)response;
        if(httpResp.statusCode<200||httpResp.statusCode>=300){
            id pkg=[NSJSONSerialization JSONObjectWithData:data
                                                   options:0 error:&parseErr];
            if(!pkg){
                NSLog(@"Error: Couldn't parse response:%@",parseErr);
                return;
            }
        
        
            NSString *imageURLStr=pkg[@"data"][0][@"image"][@"standard_resolution"][@"url"];
            NSURL *imageURL=[NSURL URLWithString:imageURLStr];
            [[session dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                //Check for network error
                if(error){
                    NSLog(@"Error:Couldn't finish rquest :%@",error);
                    return;
                }
                if(httpResp.statusCode<200||httpResp.statusCode>=300){
                    NSLog(@"Error : Got status code %ld",httpResp.statusCode);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imgPhoto.image=[UIImage imageWithData:data];
                });
                
            }] resume];
        }
    }] resume];

}

@end
