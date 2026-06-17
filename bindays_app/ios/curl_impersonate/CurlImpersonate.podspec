Pod::Spec.new do |s|
  s.name             = 'CurlImpersonate'
  s.version          = '2.0.0'
  s.summary          = 'libcurl-impersonate native library for BinDays (dart:ffi).'
  s.description       = <<-DESC
Static libcurl-impersonate xcframework providing browser TLS/JA3 + HTTP/2
impersonation for the BinDays app on iOS, consumed via dart:ffi. The binary is
downloaded by the Podfile from the bindays_client GitHub release (pinned by
native_libs.version) into this directory and vendored as a local pod.
  DESC
  s.homepage         = 'https://github.com/BadgerHobbs/BinDays-Client'
  s.license          = { :type => 'MIT' }
  s.author           = 'lexiforest'
  s.platform         = :ios, '13.0'
  # Not used (consumed as a local :path pod); required by the spec format.
  s.source           = { :git => 'https://github.com/BadgerHobbs/BinDays-Client.git' }
  s.vendored_frameworks = 'libcurl-impersonate.xcframework'
  # The xcframework is a *static* library, linked into the app executable. FFI
  # only references curl_* at runtime, so (a) force the linker to keep each used
  # symbol's object (-u, which also defeats dead-stripping), and (b) export them
  # into the dynamic symbol table so dart:ffi DynamicLibrary.process() can dlsym
  # them. libcurl-impersonate also depends on the system libiconv (iconv*) and
  # libicucore (uidna*, for internationalized domain names), so link those too.
  s.libraries = 'iconv', 'icucore'
  s.user_target_xcconfig = {
    'OTHER_LDFLAGS' => '-Wl,-u,_curl_global_init -Wl,-u,_curl_easy_init ' \
      '-Wl,-u,_curl_easy_setopt -Wl,-u,_curl_easy_perform ' \
      '-Wl,-u,_curl_easy_getinfo -Wl,-u,_curl_easy_cleanup ' \
      '-Wl,-u,_curl_easy_impersonate -Wl,-u,_curl_slist_append ' \
      '-Wl,-u,_curl_slist_free_all -Wl,-export_dynamic',
  }
end
