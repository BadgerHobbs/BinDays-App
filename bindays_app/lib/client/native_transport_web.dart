// External Imports
import 'package:dio/dio.dart';

/// Web has no native HTTP stack to substitute, so keep the default transport.
HttpClientAdapter? createNativeAdapter() => null;
