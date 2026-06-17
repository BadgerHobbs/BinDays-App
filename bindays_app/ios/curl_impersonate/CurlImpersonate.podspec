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
Static libcurl-impersonate xcframework published by the bindays_client repo,
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
  s.vendored_frameworks = 'libcurl-impersonate.xcframework'
  # The xcframework is a *static* library, linked into the app executable. FFI
  # only references curl_* at runtime, so (a) force the linker to keep each used
  # symbol's object (-u, which also defeats dead-stripping without needing a
  # build-dir path like -force_load did), and (b) export them into the dynamic
  # symbol table so dart:ffi DynamicLibrary.process() can dlsym them.
  s.user_target_xcconfig = {
    'OTHER_LDFLAGS' => '-Wl,-u,_curl_global_init -Wl,-u,_curl_easy_init ' \
      '-Wl,-u,_curl_easy_setopt -Wl,-u,_curl_easy_perform ' \
      '-Wl,-u,_curl_easy_getinfo -Wl,-u,_curl_easy_cleanup ' \
      '-Wl,-u,_curl_easy_impersonate -Wl,-u,_curl_slist_append ' \
      '-Wl,-u,_curl_slist_free_all -Wl,-export_dynamic',
  }
end
