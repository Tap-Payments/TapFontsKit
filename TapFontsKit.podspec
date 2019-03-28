TapAdditionsKitDependencyVersion    = '>= 1.3.1'     unless defined? TapAdditionsKitDependencyVersion
TapSwiftFixesDependencyVersion      = '>= 1.0.8'   unless defined? TapSwiftFixesDependencyVersion

Pod::Spec.new do |tapFontsKit|
    
    tapFontsKit.platform 				= :ios
    tapFontsKit.ios.deployment_target	= '8.0'
	tapFontsKit.swift_versions 			= ['4.2', '5.0']
    tapFontsKit.name 					= 'TapFontsKit'
    tapFontsKit.summary 				= 'Kit with fonts used in Tap mobile apps & frameworks.'
    tapFontsKit.requires_arc 			= true
    tapFontsKit.version 				= '1.0.5'
    tapFontsKit.license 				= { :type => 'MIT', :file => 'LICENSE' }
    tapFontsKit.author 					= { 'Tap Payments' => 'hello@tap.company' }
    tapFontsKit.homepage 				= 'https://github.com/Tap-Payments/TapFontsKit'
    tapFontsKit.source 					= { :git => 'https://github.com/Tap-Payments/TapFontsKit.git', :tag => tapFontsKit.version.to_s }
    tapFontsKit.source_files 			= 'TapFontsKit/Source/*.swift'
    tapFontsKit.ios.resource_bundle 	= { 'Fonts' => 'TapFontsKit/Resources/*.ttf' }
    
    tapFontsKit.dependency 'TapAdditionsKit/Foundation/Bundle',	TapAdditionsKitDependencyVersion
	tapFontsKit.dependency 'TapAdditionsKit/Foundation/Locale',	TapAdditionsKitDependencyVersion
    tapFontsKit.dependency 'TapSwiftFixes/Threading',			TapSwiftFixesDependencyVersion
    
end
