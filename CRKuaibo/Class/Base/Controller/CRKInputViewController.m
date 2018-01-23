//
//  CRKInputViewController.m
//  CRKuaibo
//
//  Created by ylz on 16/5/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKInputViewController.h"
#import "CRKURLRequest.h"
#import "CRKErrorHandler.h"

@interface CRKInputViewController ()<UITextViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UITextView *_inputTextView;
    UILabel *_textLimitLabel;
    UILabel *_placeholderLabel;
    UIButton *_commitBtn;
}

@end

@implementation CRKInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _inputTextView = [[UITextView alloc] init];
    _inputTextView.font = [UIFont systemFontOfSize:14.];
    _inputTextView.backgroundColor = [UIColor whiteColor];
    _inputTextView.layer.cornerRadius = 4;
    _inputTextView.layer.borderWidth = 0.5;
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    _inputTextView.delegate = self;
    //    _inputTextView.placeholder = self.placeholder;
    _inputTextView.text = self.text;
    [self.view addSubview:_inputTextView];
    {
        [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.view).offset(35/667.*kScreenHeight);
            make.right.equalTo(self.view).offset(-15);
            make.height.mas_equalTo(180/667.*kScreenHeight);
        }];
    }
    //占位符
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    _placeholderLabel.text = @"欢迎反馈任何意见和建议";
    [self.view addSubview:_placeholderLabel];
    {
        [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_inputTextView).mas_offset(5);
            make.top.mas_equalTo(_inputTextView.mas_top).mas_offset(6);
        }];
        
    }
    UIButton *commitBtn = [[UIButton alloc] init];
    _commitBtn = commitBtn;
    commitBtn.layer.cornerRadius = 4;
    commitBtn.layer.masksToBounds = YES;
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"inputBtn"] forState:UIControlStateNormal];
    [commitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"inputBtn"] forState:UIControlStateHighlighted];
    [commitBtn setTitle:@"提交反馈" forState:UIControlStateHighlighted];
    @weakify(self);
    [commitBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self doSave];
        //        [_inputTextView becomeFirstResponder];
        
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_inputTextView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(_inputTextView);
        make.height.mas_equalTo(44);
    }];
    //下面的view,给view添加手势,取消键盘第一响应
    UIView *belowView = [[UIView alloc] init];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [belowView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    belowView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:belowView];
    [belowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(commitBtn.mas_bottom);
    }];
}

- (void)handleSingleTap {
    [_inputTextView resignFirstResponder];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_inputTextView becomeFirstResponder];
}

//- (void)setPlaceholder:(NSString *)placeholder {
//    _placeholder = placeholder;
////    _inputTextView.placeholder = placeholder;
//}

- (void)setText:(NSString *)text {
    _text = text;
    _inputTextView.text = text;
}

- (void)setLimitedTextLength:(NSUInteger)limitedTextLength {
    _limitedTextLength = limitedTextLength;
    
    if (limitedTextLength > 0 && !_textLimitLabel) {
        _textLimitLabel = [[UILabel alloc] init];
        _textLimitLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _textLimitLabel.text = [NSString stringWithFormat:@"%ld", limitedTextLength - self.text.length];
        _textLimitLabel.font = [UIFont systemFontOfSize:14.];
        [self.view addSubview:_textLimitLabel];
        {
            [_textLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_inputTextView).offset(-15);
                make.bottom.equalTo(_inputTextView.mas_bottom).offset(-15);
            }];
        }
    }
    _textLimitLabel.hidden = limitedTextLength == 0;
}

- (void)doSave {
    [_inputTextView resignFirstResponder];
    if (_inputTextView.text.length != 0) {
        _commitBtn.enabled = NO;
//        CRKURLResponseStatus resp = (CRKURLResponseStatus)(((NSNumber *)userInfo[kNetworkErrorCodeKey]).unsignedIntegerValue);
        
        CGFloat time = arc4random_uniform(2)+0.5;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _inputTextView.text = nil;
            _textLimitLabel.text = @"140";
            [[CRKHudManager manager] showHudWithText:@"提交成功!"];
            _commitBtn.enabled = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    }else {
        [[CRKHudManager manager] showHudWithText:@"内容不能为空"];
        
    }
}

- (void)doChangeText {
    _text = _inputTextView.text;
    
    if (self.limitedTextLength > 0) {
        _textLimitLabel.text = [NSString stringWithFormat:@"%ld", self.limitedTextLength - self.text.length];
    }
    
//    if (self.changeHandler) {
//        self.navigationItem.rightBarButtonItem.enabled = self.changeHandler(self, self.text);
//    } else {
//        self.navigationItem.rightBarButtonItem.enabled = _text.length > 0;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView {
    if (_inputTextView.text.length == 0) {
        _placeholderLabel.hidden = NO;
    }else{
        _placeholderLabel.hidden = YES;
    }
    [self doChangeText];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (_inputTextView.text.length == 0) {
        _placeholderLabel.hidden = NO;
    }else{
        _placeholderLabel.hidden = YES;
    }
    NSUInteger newTextLength = textView.text.length - range.length + text.length;
    if (self.limitedTextLength > 0 && newTextLength > self.limitedTextLength) {
        return NO;
    }
    return YES;
}

- (void)dealloc {
    
    
}


@end
