//
//  ViewController.m
//  webSocket
//
//  Created by 瓮守玉 on 2017/12/9.
//  Copyright © 2017年 ranhan. All rights reserved.
//

#import "ViewController.h"

#import "SRWebSocket.h"
@interface ViewController ()<SRWebSocketDelegate>

@property(nonatomic,strong)SRWebSocket *webSocket;
@property(nonatomic,strong)UILabel *replyContent;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.backgroundColor=[UIColor greenColor];
    sendBtn.frame=CGRectMake(100, 240, 80, 30);
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    
    self.replyContent=[[UILabel alloc]init];
    self.replyContent.frame=CGRectMake(100, 150, 200, 50);
    self.replyContent.backgroundColor=[UIColor blueColor];
    self.replyContent.textColor=[UIColor redColor];
    [self.view addSubview:self.replyContent];
    
   
}

-(void)viewWillAppear:(BOOL)animated{

    [self reconnect];
}

//关闭webSocket
- (void)viewDidDisappear:(BOOL)animated{
    // Close WebSocket
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;
}
//初始化websocket
- (void)reconnect{
    self.webSocket.delegate = nil;
    [self.webSocket close];
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://echo.websocket.org"]]];
    self.webSocket.delegate = self;
    
    self.title = @"Opening Connection...";
    
    [self.webSocket open];
}

//代理方法实现
#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"连接成功!");
    self.title = @"Connected!";
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@":( 连接失败 %@", error);
    
    self.title = @"Connection Failed! (see logs)";
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"收到数据!%@",message);

    NSString *str2 = message;
    self.replyContent.text = str2;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"连接断开:%@",reason);
    self.title = @"Connection Closed! (see logs)";
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"%@",reply);
}

#pragma mark - SendButton Response
- (void)sendAction:(id)sender {
    [self.view endEditing:YES];
    // WebSocket
    if (self.webSocket) {
        [self.webSocket send:@"test success"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
