Pod::Spec.new do |s|
    s.name             = "KVConstraintExtensionsMaster"
    s.version          = "1.0.0"

    s.summary          = "KVConstraintExtensionsMaster is a simple auto-layout lirary, to apply, access or modify already added constraint on any view."
    s.description      = "# KVConstraintExtensionsMaster is a simple auto-layout lirary, by which you can directly access or modify already applied constraint (means expected constraint) either applied Programatically or applied from Interface Builder on any view. So No need to use more IBOutlet reference."

    s.homepage         = "https://github.com/keshavvishwkarma/KVConstraintExtensionsMaster"
    s.license          = 'MIT'
    s.author           = { "keshav vishwkarma" => "keshavvbe@gmail.com" }
    s.platform         = :ios, '7.0'
    s.source           = { :git => "https://github.com/keshavvishwkarma/KVConstraintExtensionsMaster.git", :tag => s.version }

    s.source_files = 'KVConstraintExtensionsMaster/*.{h,m}'
    s.requires_arc = true

end