//
//  FontProvider.swift
//  TapFontsKit
//
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import struct 	CoreGraphics.CGBase.CGFloat
import class 	CoreGraphics.CGDataProvider.CGDataProvider
import class 	CoreGraphics.CGFont.CGFont
import func 	CoreText.CTFontManager.CTFontManagerRegisterGraphicsFont
import struct	TapAdditionsKit.BundleAdditions
import func 	TapSwiftFixes.synchronized
import class	UIKit.UIFont.UIFont

/*!
 @class         FontProvider
 @abstract      Utility class to retreive localized fonts.
 */
public class FontProvider {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Returns localized variant of font with a given original name of a given size for a given locale.
    ///
    /// - Parameters:
    ///   - originalName: Original font name.
    ///   - size: Font size
    ///   - languageIdentifier: Language identifier.
    /// - Returns: UIFont
    public static func localizedFont(_ originalName: TapFont, size: CGFloat, languageIdentifier: String) -> UIFont {
        
        var fontName: TapFont
        
        #if TARGET_INTERFACE_BUILDER
            
            fontName = originalName
            
        #else
            
            if languageIdentifier == Locale.LocaleIdentifier.ar {
                
                fontName = self.arabicFontNames[originalName] ?? .arabicHelveticaNeueRegular
            }
            else {
                
                fontName = originalName
            }
            
        #endif
        
        return self.fontWith(name: fontName, size: size)
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func fontWith(name: TapFont, size: CGFloat) -> UIFont {
        
        return synchronized(self.loadedFonts) {
            
            if !self.loadedFonts.contains(name) {
                
                self.loadFont(name)
                self.loadedFonts.insert(name)
            }
            
            guard let font = UIFont(name: name.fileName, size: size) else {
                
                fatalError("Failed to instantiate font \(name.fileName)")
            }
            
            return font
        }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let resourcesBundleName = "Fonts"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private static var arabicFontNames: [TapFont: TapFont] = {
        
        return [
            
            .helveticaNeueThin: 	.arabicHelveticaNeueLight,
            .helveticaNeueLight: 	.arabicHelveticaNeueLight,
            .helveticaNeueMedium: 	.arabicHelveticaNeueRegular,
            .helveticaNeueRegular:	.arabicHelveticaNeueRegular,
            .helveticaNeueBold: 	.arabicHelveticaNeueBold,
            .circeExtraLight: 		.arabicHelveticaNeueLight,
            .circeLight: 			.arabicHelveticaNeueLight,
            .circeRegular: 			.arabicHelveticaNeueRegular,
            .circeBold: 			.arabicHelveticaNeueBold
        ]
    }()
    
    private static var loadedFonts: Set<TapFont> = {
        
        let fonts: [TapFont] = [
            
            .helveticaNeueThin,
            .helveticaNeueLight,
            .helveticaNeueMedium,
            .helveticaNeueRegular,
            .helveticaNeueBold
        ]
        
        return Set<TapFont>(fonts)
    }()
    
    private static let resourcesBundle: Bundle = {
       
        guard let bundle = Bundle(for: FontProvider.self).childBundle(named: Constants.resourcesBundleName) else {
            
            fatalError("There is no bundle named \(Constants.resourcesBundleName)")
        }
        
        return bundle
    }()
    
    // MARK: Methods
    
    @available(*, unavailable) private init() {}
    
    private static func loadFont(_ fontName: TapFont) {
        
        guard let fontURL = self.resourcesBundle.url(forResource: fontName.fileName, withExtension: fontName.fileExtension) else {
            
            fatalError("There is no \(fontName.fileName).\(fontName.fileExtension) in fonts bundle.")
        }
        
        guard let fontData = try? Data(contentsOf: fontURL) else {
            
            fatalError("Failed to load \(fontName.fileName).\(fontName.fileExtension) from fonts bundle.")
        }
        
        guard let dataProvider = CGDataProvider(data: fontData as CFData) else {
            
            fatalError("Font data for \(fontName.fileName).\(fontName.fileExtension) is incorrect.")
        }
        
        guard let font = CGFont(dataProvider) else {
            
            fatalError("Font data for \(fontName.fileName).\(fontName.fileExtension) is incorrect.")
        }
        
        var error: Unmanaged<CFError>? = nil
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            
            if let nonnullError = error, let errorDescription = CFErrorCopyDescription(nonnullError.takeRetainedValue()) {
				
                fatalError("Error occured while registering font: \(errorDescription)")
            }
        }
    }
}
