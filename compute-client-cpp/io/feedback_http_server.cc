#include "io/feedback_http_server.h"

#include <string>
#include <atomic>

#include "absl/flags/flag.h"
#include "absl/log/check.h"
#include "absl/log/log.h"
#include "httplib.h"

ABSL_FLAG(std::string, http_server_static_serving_path, "",
    "Path to serve static files in HTTP server.");
ABSL_FLAG(int32_t, http_server_port, -1,
    "Port number for the HTTP server.");

namespace genart {

using ::httplib::Request;
using ::httplib::Response;

class FeedbackHttpServer::ServerImpl {
 public:
  void PrepareOrDie();

  // Does not return.
  void ListenLoop();

  // Handles race condition, will only kill the wrapped server once.
  void StopServer();

 private:
  int32_t port_ = -1;
  httplib::Server server_;
  std::atomic_bool stopped_{false};
};

void FeedbackHttpServer::ServerImpl::PrepareOrDie() {
  port_ = absl::GetFlag(FLAGS_http_server_port);
  CHECK_GT(port_, 0);

  // Mount '/' to the static files directory
  const std::string static_path = absl::GetFlag(
      FLAGS_http_server_static_serving_path);
  CHECK(!static_path.empty());
  LOG(INFO) << "Serving static files from root: " << static_path;
  CHECK(server_.set_mount_point("/", static_path));

  // handler to stop the server.
  server_.Get("/abort", [this](const Request& req, Response& res) {
    StopServer();
  });
}

void FeedbackHttpServer::ServerImpl::ListenLoop() {
  server_.listen("localhost", port_);
}

void FeedbackHttpServer::ServerImpl::StopServer() {
  LOG(INFO) << "Stop (server) requested.";
  bool expected_stopped = stopped_.load();
  if (expected_stopped) return;
  bool can_stop = stopped_.compare_exchange_strong(expected_stopped, true);
  if (can_stop) {
    server_.stop();
  }
}

//------------------------------------------------------------------------------
FeedbackHttpServer::FeedbackHttpServer() {
  server_impl_ = std::make_unique<ServerImpl>();
}

FeedbackHttpServer::~FeedbackHttpServer() {
  server_impl_->StopServer();
  if (listen_thread_.joinable()) {
    listen_thread_.join();
  }
}

void FeedbackHttpServer::Start() {
  LOG(INFO) << "Starting httrp server ..";
  server_impl_->PrepareOrDie();
  listen_thread_ = std::thread(std::bind(
    &ServerImpl::ListenLoop, server_impl_.get()));
}

void FeedbackHttpServer::Wait() {
  listen_thread_.join();
}

}  // namespace genart