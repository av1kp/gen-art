# Client code that handles computations, talks to 'processing' sketch.

cc_binary(
   name = "main",
   srcs = ["main.cc"],
   deps = [
      "//clients/interlocked:art_generator",
      "//io:feedback_http_server",
      "//io:json_handler",
      "//io:sketch_client_socket",
      "@com_google_absl//absl/flags:parse",
      "@com_google_absl//absl/log:log",
      "@com_google_absl//absl/strings",
    ],
)