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
  # references curl_* only at runtime (via DynamicLibrary.process() ->
  # dlsym(RTLD_DEFAULT)), so the linker sees them as unused. For dlsym to find
  # them in the final binary they must be in its *export trie*, and must stay
  # there through the Release build's strip step. We therefore, for each used
  # symbol:
  #   (a) -u             force its object to be linked (and root it against
  #                      dead-stripping), and
  #   (b) -exported_symbol  add it to the export trie as a required export.
  # An explicit -exported_symbol per symbol is used instead of the blanket
  # -export_dynamic: the latter worked in the debug simulator build but did not
  # survive Release stripping on device, leaving dlsym unable to find the
  # symbols. The export trie is load-command metadata that strip never removes
  # (dlsym(RTLD_DEFAULT) reads it, not the nlist symbol table), so these exports
  # survive the host app's default STRIP_STYLE=all with no need to weaken it.
  # libcurl-impersonate also depends on the system libiconv (iconv*) and
  # libicucore (uidna*, for internationalized domain names), so link those too.
  s.libraries = 'iconv', 'icucore'
  s.user_target_xcconfig = {
    'OTHER_LDFLAGS' => '-Wl,-u,_curl_global_init -Wl,-u,_curl_easy_init ' \
      '-Wl,-u,_curl_easy_setopt -Wl,-u,_curl_easy_perform ' \
      '-Wl,-u,_curl_easy_getinfo -Wl,-u,_curl_easy_cleanup ' \
      '-Wl,-u,_curl_easy_impersonate -Wl,-u,_curl_slist_append ' \
      '-Wl,-u,_curl_slist_free_all ' \
      '-Wl,-exported_symbol,_curl_global_init ' \
      '-Wl,-exported_symbol,_curl_easy_init ' \
      '-Wl,-exported_symbol,_curl_easy_setopt ' \
      '-Wl,-exported_symbol,_curl_easy_perform ' \
      '-Wl,-exported_symbol,_curl_easy_getinfo ' \
      '-Wl,-exported_symbol,_curl_easy_cleanup ' \
      '-Wl,-exported_symbol,_curl_easy_impersonate ' \
      '-Wl,-exported_symbol,_curl_slist_append ' \
      '-Wl,-exported_symbol,_curl_slist_free_all',
  }
end
