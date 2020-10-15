//
//  DemoNewsCCell.m
//  EaseModule_Example
//
//  Created by rocky on 2020/9/28.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "DemoNewsCCell.h"
#import <WebKit/WKWebView.h>

@implementation NewsInfoCCell{
    UILabel * _titleLabel;
    UILabel * _authorNameLabel;
    UILabel * _publicTimeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        _authorNameLabel = [UILabel new];
        _authorNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _authorNameLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_authorNameLabel];
        
        _publicTimeLabel = [UILabel new];
        _publicTimeLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        _publicTimeLabel.textColor = [UIColor colorWithHexString:@"#5B5B5B"];
        [self.contentView addSubview:_publicTimeLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(5);
            make.right.equalTo(self.contentView).mas_offset(-5);
            make.top.equalTo(self.contentView).mas_offset(5);
            make.height.mas_greaterThanOrEqualTo(20);
        }];
        
        [_authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_publicTimeLabel.mas_right).mas_offset(10);
            make.top.equalTo(self->_titleLabel.mas_bottom).mas_offset(4);
            make.height.mas_equalTo(20);
        }];
        
        [_publicTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_titleLabel);
            make.height.mas_equalTo(self->_authorNameLabel);
            make.centerY.equalTo(self->_authorNameLabel);
        }];
    }
    return self;
}

- (void) setupWithData:(id)data{
    _titleLabel.text = data[@"title"];
    _authorNameLabel.text = data[@"author"];
    _publicTimeLabel.text = data[@"publicTime"];
}

@end

@interface NewsContentCCell ()<
WKNavigationDelegate>
@end

@implementation NewsContentCCell{
    WKWebView * _webView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor randomColor];
//        WKUserContentController* userContentController = WKUserContentController.new;
//        WKUserScript * cookieScript = [[WKUserScript alloc]
//                                        initWithSource: cookieValue
//                                        injectionTime:WKUserScriptInjectionTimeAtDocumentStart
//                                        forMainFrameOnly:NO];
//        [userContentController addUserScript:cookieScript];
//        [userContentController addScriptMessageHandler:self name:@"loadComplete"];
//
//        config.userContentController = userContentController;
//
        _webView = [WKWebView new];
        _webView.navigationDelegate = self;
        [self.contentView addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void) setupWithData:(id)data{
    [_webView loadHTMLString:EaseSafeString(data) baseURL:nil];
}

#pragma mark - WKNavigationDelegate

/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [webView evaluateJavaScript:@"document.body.scrollHeight;"
    completionHandler:^(id _Nullable any, NSError * _Nullable error) {
        if ([self.delegate respondsToSelector:@selector(newsContentCCell:didFinishUpdateHeight:)]) {
            [self.delegate newsContentCCell:self didFinishUpdateHeight:[any floatValue] * 0.3];
        }
        NSLog(@"webHeight---%@",any);
    }];
    NSLog(@"webHeight 实际高度---%@",NSStringFromCGSize(webView.scrollView.contentSize));
}

// 主界面加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}
@end

@implementation NewsKeywordCCell{
    UILabel *_oneLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = 4.0f;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        
        _oneLabel = [UILabel new];
        _oneLabel.textAlignment = NSTextAlignmentCenter;
        _oneLabel.textColor = [UIColor redColor];
        _oneLabel.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:_oneLabel];
        
        [_oneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset(5);
            make.right.equalTo(self.contentView).mas_offset(-5);
        }];
    }
    return self;
}

- (void) setupWithData:(id)data{
    _oneLabel.text = EaseSafeString(data);
}

@end

@implementation NewsRecommendCCell{
    UILabel *_titleLabel;
    UIView *_titleBgView;
    UIImageView *_iconImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor randomColor];
        
        self.contentView.layer.cornerRadius = 4.0f;
        self.contentView.layer.masksToBounds = YES;
        
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconImageView];
        
        _titleBgView = [UIView new];
        _titleBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.contentView addSubview:_titleBgView];
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        [_titleBgView addSubview:_titleLabel];

        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_titleBgView).mas_offset(4);
            make.right.equalTo(self->_titleBgView).mas_offset(-4);
            make.bottom.equalTo(self->_titleBgView).mas_offset(-4);
            make.height.mas_greaterThanOrEqualTo(20);
        }];
        [_titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self->_titleLabel).mas_offset(-4);
        }];
    }
    return self;
}

- (void) setupWithData:(id)data{
    
    NSString * title = data[@"title"];
    NSString * cover = data[@"bigCover"];
    if (data[@"replaced"] && !title && !cover) {
        title = data[@"replaced"][@"title"];
        cover = data[@"replaced"][@"bigCover"];
    }
    [_iconImageView sd_setImageWithURL:EaseSafeURL(({
        [NSString stringWithFormat:@"https:%@",cover];
    }))];
    _titleLabel.text = EaseSafeString(title);
}

@end
