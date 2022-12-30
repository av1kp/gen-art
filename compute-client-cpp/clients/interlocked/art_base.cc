#include "clients/interlocked/art_base.h"

#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"

namespace genart {

using ::geometry::IntRect2D;
using ::rapidjson::Document;
using ::rapidjson::StringBuffer;
using ::rapidjson::Writer;
using ::rapidjson::Value;
using ::rapidjson::kArrayType;
using ::rapidjson::kObjectType;

Value ParseBlock(
    const ArtPiece::Block& block,
    Document::AllocatorType& alloc) {
  Value json{kObjectType};
  {
    Value v(block.bound.ToCompactString(), alloc);
    json.AddMember("bound", v.Move(), alloc);
  }
  {
    Value v(kArrayType);
    for (int i = 0; i < block.gaps.size(); ++i) {
      Value strval(block.gaps[i].ToCompactString(), alloc);
      v.PushBack(strval.Move(), alloc);
    }
    json.AddMember("gaps", v, alloc);
  }
  return json;
}

std::string ArtPiece::ToJsonString() const {
  using ::geometry::Rect2D;

  Document document;
  document.SetObject();
  Document::AllocatorType& alloc = document.GetAllocator();

  Value blockvals(kArrayType);
  for (int i = 0; i < blocks_.size(); ++i) {
    blockvals.PushBack(ParseBlock(blocks_[i], alloc), alloc);
  }
  document.AddMember("blocks", blockvals, alloc);

  // 3. Stringify the DOM
  StringBuffer buffer;
  Writer<StringBuffer> writer(buffer);
  document.Accept(writer);
  return buffer.GetString();
}

void ArtPiece::FillDummyValues() {
  auto b0 = Block{
    .bound = {0, 0, 8, 8},
    .gaps = {{2, 2, 6, 6}},
  };
  auto b1 = Block{
    .bound = {10, 0, 18, 8},
    .gaps = {{12, 2, 16, 6}},
  };
  auto b2 = Block{
    .bound = {20, 0, 28, 8},
    .gaps = {{22, 2, 26, 6}},
  };
  auto b3 = Block{
    .bound = {30, 0, 38, 8},
    .gaps = {{32, 2, 36, 6}},
  };

  auto c0 = Block{
    .bound = {5, 10, 23, 12},
    .gaps = {{7, 12, 11, 10}},
  };
  auto c1 = Block{
    .bound = {15, 10, 23, 18},
    .gaps = {{17, 12, 21, 16}},
  };
  auto c2 = Block{
    .bound = {25, 10, 33, 18},
    .gaps = {{27, 12, 31, 16}},
  };


  blocks_ = {b0, b1, b2, b3, c0, c1, c2};
}

}  // namespace genart