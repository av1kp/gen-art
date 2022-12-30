#pragma once

#include <memory>
#include <thread>

namespace genart {

// Runs a tiny HTTP server in a separate thread.
class FeedbackHttpServer final {
 public:
  FeedbackHttpServer();
  ~FeedbackHttpServer();

  // Starts the HTTP server, non-blocking.
  void Start();

  // Blocks until the server is interrupted.
  void Wait();

 private:
  class ServerImpl;

  std::unique_ptr<ServerImpl> server_impl_;
  std::thread listen_thread_;
};

}  // namespace genart