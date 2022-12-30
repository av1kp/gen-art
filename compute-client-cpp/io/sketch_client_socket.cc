#include "io/sketch_client_socket.h"

#include <arpa/inet.h>
#include <sys/socket.h>
#include <iostream>

#include "absl/log/check.h"
#include "absl/log/log.h"
#include "absl/strings/str_cat.h"

namespace genart {

const int32_t kSketchServerPort = 5204;

struct SketchClientSocket::InternalSocketData {
  struct sockaddr_in serv_addr;
};

//------------------------------------------------------------------------------
SketchClientSocket::SketchClientSocket() {
  data_ = std::make_unique<InternalSocketData>();
  data_->serv_addr.sin_family = AF_INET;
  data_->serv_addr.sin_port = htons(kSketchServerPort);
  // Convert IPv4 and IPv6 addresses from text to binary form.
  if (inet_pton(AF_INET, "127.0.0.1", &data_->serv_addr.sin_addr) <= 0) {
    LOG(FATAL) << "Invalid address / address not supported";
  }
}

SketchClientSocket::~SketchClientSocket() = default;

void SketchClientSocket::SendData(const std::string& content) {
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        printf("\n Socket creation error \n");
        //return -1;
    }
    // Zero the buffer.
    memset(buffer_, 0, 1024);

    int client_fd = connect(sock, (struct sockaddr*)&data_->serv_addr,
                   sizeof(data_->serv_addr));
    if (client_fd < 0) {
        LOG(FATAL) << "Connection Failed: " << client_fd;
    }
    send(sock, content.c_str(), content.size(), 0);
    printf("message sent ...\n");
    // int valread = read(sock, buffer_, 1024);
    // CHECK(valread > 0);
    // LOG(INFO) << "Read buffer = " << std::string(buffer_);
}

}  // namespace genart