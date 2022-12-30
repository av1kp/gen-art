# Net, storage related utils.

package(
    default_visibility = ["//visibility:public"],
)

cc_library(
   name = "json_handler",
   srcs = ["json_handler.cc"],
   hdrs = ["json_handler.h"],
   deps = [
      "@com_google_absl//absl/log:check",
      "@com_google_absl//absl/log:log",
      "@com_google_absl//absl/strings",
       "@rapidjson",
   ],
)


cc_library(
   name = "sketch_client_socket",
   srcs = ["sketch_client_socket.cc"],
   hdrs = ["sketch_client_socket.h"],
   deps = [
       "@com_google_absl//absl/log:check",
      "@com_google_absl//absl/log:log",
   ],
)

cc_library(
   name = "feedback_http_server",
   srcs = ["feedback_http_server.cc"],
   hdrs = [
      "feedback_http_server.h",
      #"httplib.h",
   ],
   deps = [
      "@com_google_absl//absl/flags:flag",
      "@com_google_absl//absl/log:check",
      "@com_google_absl//absl/log:log",
      "@com_google_absl//absl/strings",
      "@cpp_httplib",
   ],
)