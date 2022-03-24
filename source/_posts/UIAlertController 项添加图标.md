---
title: UIAlertController 项添加图标
url: 270.html
id: 270
date: 2018-01-20 14:41:06
tags:
---

```object-c

(void)savePreset {

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Preset to Remoter buttons" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * preset1 = [UIAlertAction actionWithTitle:@"Preset1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"send preset 1");
    }];
    
    UIAlertAction * preset2 = [UIAlertAction actionWithTitle:@"Preset2" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"send preset 2");
    }];
    
    UIAlertAction * preset3 = [UIAlertAction actionWithTitle:@"Preset3" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"send preset 3");
    }];
    
    UIAlertAction * preset4 = [UIAlertAction actionWithTitle:@"Preset4" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"send preset 4");
    }];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                    handler:^(UIAlertAction * action) {}];
    
    [alertController addAction:defaultAction];
    
    [preset1 setValue:[[UIImage imageNamed:@"fire"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [preset2 setValue:[[UIImage imageNamed:@"left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [preset3 setValue:[[UIImage imageNamed:@"right"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [preset4 setValue:[[UIImage imageNamed:@"down"] imageWithRenderingMode:UIImageRenderingModeAutomatic] forKey:@"image"];
    [alertController addAction:preset1];
    [alertController addAction:preset2];
    [alertController addAction:preset3];
    [alertController addAction:preset4];
    [self presentViewController:alertController animated:YES completion:nil];
    

}

```