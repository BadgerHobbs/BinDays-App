Pod::Spec.new do |s|
  s.name             = 'CurlImpersonate'
  s.version          = '0.1.0'
  s.summary          = 'libcurl-impersonate native library for BinDays (dio_impersonate FFI).'
  s.description       = <<-DESC
Self-contained libcurl-impersonate packaged as an xcframework, providing browser
TLS/JA3 + HTTP/2 impersonation for the BinDays app on iOS. Built by the
Dio-Impersonate repo's native/build_ios.sh and consumed here via dart:ffi.
  DESC
  s.homepage         = 'https://github.com/BadgerHobbs/Dio-Impersonate'
  s.license          = { :type => 'MIT' }
  s.author           = { 'BadgerHobbs' => 'andyjriggs@gmail.com' }
  s.platform         = :ios, '13.0'
  s.source           = { :path => '.' }
  s.vendored_frameworks = 'Frameworks/CurlImpersonate.xcframework'
end
