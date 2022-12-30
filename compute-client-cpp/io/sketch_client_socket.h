#pragma once

#include <memory>
#include <string>

namespace genart {

class SketchClientSocket {
 public:
  SketchClientSocket();
  ~SketchClientSocket();

  void SendData(const std::string& content);

 private:
  struct InternalSocketData;

  std::unique_ptr<InternalSocketData> data_;
  char buffer_[1024];
  //const std::string name_;
};

}  // namespace genart