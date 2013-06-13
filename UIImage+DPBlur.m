//
//  UIImage+DPBlur.m
//  AlfaMenu
//
//  Created by ILYA2606 on 13.06.13.
//  Copyright (c) 2013 Darkness Production. All rights reserved.
//

#import "UIImage+DPBlur.h"

@implementation UIImage (DPBlur)

-(UIImage*)getBlurredImage{
    return [self getBlurredImageWithTintColor:nil];
}

-(UIImage*)getDarkBlurredImage{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self getBlurredImageWithTintColor:tintColor];
}

-(UIImage*)getLightBlurredImage{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self getBlurredImageWithTintColor:tintColor];
}

-(UIImage*)getExtraLightBlurredImage{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.81];
    return [self getBlurredImageWithTintColor:tintColor];
}

- (UIImage*)getBlurredImageWithTintColor:(UIColor*)tintColor
{
    // Создаем контекст для изображения с блюром
    CIContext *context = [CIContext contextWithOptions:nil];
    // Ковертируем изображение в CIImage
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    // Настраиваем фильтр "Gaussian Blur"
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    // Устанавливаем к фильтру входящее изображение
    [filter setValue:inputImage forKey:kCIInputImageKey];
    // Настраиваем радиус размытия
    CGFloat blurRadius = 15.0f;
    // Устанавливаем к фильтру радиус размытия
    [filter setValue:[NSNumber numberWithFloat:blurRadius] forKey:@"inputRadius"];
    // Получаем изображение с блюром.
    // ВНИМАНИЕ: Итоговый размер блюра по размерам может быть меньше размера изображения из-за данного типа блюра (Gaussian Blur)
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    // Конвертируем изображение в CGImageRef
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *outputImage = nil;

    // Если имеется цвет оттенка, то добавляем его
    if (tintColor) {
        // Берем область изображения
        CGRect imageRect = { CGPointZero, self.size };
        // Настраиваем контекст для изображения с блюром
        UIGraphicsBeginImageContext(imageRect.size);
        CGContextRef outputContext = UIGraphicsGetCurrentContext();
        // Переворачиваем систему координат
        CGContextScaleCTM(outputContext, 1.0, -1.0);
        CGContextTranslateCTM(outputContext, 0, -self.size.height);
        // Рисуем изображение с блюром на контексте
        CGContextDrawImage(outputContext, imageRect, cgImage);
        // Сохраняем текущее состояние контекста
        CGContextSaveGState(outputContext);
        // Настраиваем цвет оттенка
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        // Заливаем контекст цветом оттенка
        CGContextFillRect(outputContext, imageRect);
        // Восстанавливаем состояние контекста
        CGContextRestoreGState(outputContext);
        // Получаем итоговое изображение с блюром и оттенком
        outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    else{
        // Если оттенка нет, то конвертируем изображение в UIImage
        outputImage = [UIImage imageWithCGImage:cgImage];
    }
    
    return outputImage;
}

@end
