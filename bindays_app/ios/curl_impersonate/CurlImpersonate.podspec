require 'json'
require 'uri'

# Downloads the dynamic libcurl-impersonate.xcframework published by the
# bindays_client repo. The version is the single source of truth in
# bindays_client's native_libs.version, resolved here via the Dart package
# config so the app never pins it separately. To update, bump native_libs.version
# in bindays_client and re-run its publish-native-libs workflow. The binary is
# not vendored in this repo.
pkg_config = File.expand_path(File.join(__dir__, '..', '..', '.dart_tool', 'package_config.json'))
root_uri = JSON.parse(File.read(pkg_config))['packages']
  .find { |p| p['name'] == 'bindays_client' }['rootUri']
client_dir = root_uri.start_with?('file:') ? URI(root_uri).path :
  File.expand_path(File.join(File.dirname(pkg_config), root_uri))
native_version = File.read(File.join(client_dir, 'native_libs.version')).strip

Pod::Spec.new do |s|
  s.name             = 'CurlImpersonate'
  s.version          = native_version
  s.summary          = 'libcurl-impersonate native library for BinDays (dart:ffi).'
  s.description       = <<-DESC
Dynamic libcurl-impersonate xcframework published by the bindays_client repo,
providing browser TLS/JA3 + HTTP/2 impersonation for the BinDays app on iOS,
consumed via dart:ffi.
  DESC
  s.homepage         = 'https://github.com/BadgerHobbs/BinDays-Client'
  s.license          = { :type => 'MIT' }
  s.author           = 'lexiforest'
  s.platform         = :ios, '13.0'
  s.source           = {
    :http => "https://github.com/BadgerHobbs/BinDays-Client/releases/download/native-v#{native_version}/libcurl-impersonate-ios-xcframework-v#{native_version}.tar.gz"
  }
  # Dynamic framework: its curl_* symbols are loaded into the process and
  # resolved via dart:ffi DynamicLibrary.process(); no -force_load needed (that
  # was only required for the upstream *static* xcframework).
  s.vendored_frameworks = 'libcurl-impersonate.xcframework'
end
