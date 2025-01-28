Pod::Spec.new do |s|
    s.name                    = 'scandit-datacapture-frameworks-label'
    s.version                 = '7.1.0-beta.1'
    s.summary                 = 'Scandit Frameworks Shared Label module'
    s.homepage                = 'https://github.com/Scandit/scandit-datacapture-frameworks-label'
    s.license                 = { :type => 'Apache-2.0' , :text => 'Licensed under the Apache License, Version 2.0 (the "License");' }
    s.author                  = { 'Scandit' => 'support@scandit.com' }
    s.platforms               = { :ios => '14.0' }
    s.source                  = { :git => 'https://github.com/Scandit/scandit-datacapture-frameworks-label.git', :tag => '7.1.0-beta.1' }
    s.swift_version           = '5.7'
    s.source_files            = 'Sources/**/*.{h,m,swift}'
    s.requires_arc            = true
    s.module_name             = 'ScanditFrameworksLabel'
    s.header_dir              = 'ScanditFrameworksLabel'

    s.dependency 'ScanditLabelCapture', '= 7.1.0-beta.1'
    s.dependency 'scandit-datacapture-frameworks-core', '= 7.1.0-beta.1'
end
