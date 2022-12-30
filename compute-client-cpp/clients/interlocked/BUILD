package(
    default_visibility = ["//visibility:public"],
)

cc_library(
   name = "art_base",
   srcs = ["art_base.cc"],
   hdrs = ["art_base.h"],
   deps = [
      "//geometry:primitive_types_2d",
      "@com_google_absl//absl/log:check",
      "@com_google_absl//absl/log:log",
      "@rapidjson",
   ],
)

cc_library(
   name = "art_generator",
   srcs = ["art_generator.cc"],
   hdrs = ["art_generator.h"],
   deps = [
      ":art_base",
      "//geometry:primitive_types_2d",
      "//io:sketch_client_socket",
      "@com_google_absl//absl/log:check",
      "@com_google_absl//absl/log:log",
      "@com_google_absl//absl/random",
      "@com_google_absl//absl/strings",
   ],
)