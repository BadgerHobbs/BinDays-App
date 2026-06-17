# Downloads the libcurl-impersonate xcframework from the upstream
# lexiforest/curl-impersonate release pinned in native_libs.version, so the
# binary is not vendored in this repo. To update, bump native_libs.version.
native_version = File.read(File.join(__dir__, '..', '..', 'native_libs.version')).strip

Pod::Spec.new do |s|
  s.name             = 'CurlImpersonate'
  s.version          = native_version
  s.summary          = 'libcurl-impersonate native library for BinDays (dio_impersonate FFI).'
  s.description       = <<-DESC
Prebuilt libcurl-impersonate xcframework from the upstream lexiforest release,
providing browser TLS/JA3 + HTTP/2 impersonation for the BinDays app on iOS,
consumed via dart:ffi.
  DESC
  s.homepage         = 'https://github.com/lexiforest/curl-impersonate'
  s.license          = { :type => 'MIT' }
  s.author           = 'lexiforest'
  s.platform         = :ios, '13.0'
  s.source           = {
    :http => "https://github.com/lexiforest/curl-impersonate/releases/download/v#{native_version}/libcurl-impersonate-v#{native_version}.ios-xcframework.tar.gz"
  }
  s.vendored_frameworks = 'libcurl-impersonate.xcframework'
  # The xcframework is a static library; force-load it so the curl_* symbols
  # survive dead-stripping and are resolvable via dart:ffi DynamicLibrary.process().
  s.user_target_xcconfig = {
    'OTHER_LDFLAGS' => '-force_load "${PODS_XCFRAMEWORKS_BUILD_DIR}/CurlImpersonate/libcurl-impersonate.a"'
  }
end
