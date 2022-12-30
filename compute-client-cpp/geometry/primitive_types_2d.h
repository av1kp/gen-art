#pragma once

#include <cstdint>
#include <string>

namespace geometry {

struct Point2D {
  float x = 0;
  float y = 0;

  std::string ToCompactString() const;
};

struct Rect2D {
  float xstart = 0;
  float ystart = 0;
  float xend = 0;
  float yend = 0;

   std::string ToCompactString() const;
};

struct IntRect2D {
  int32_t xstart = 0;
  int32_t ystart = 0;
  int32_t xend = 0;
  int32_t yend = 0;

   std::string ToCompactString() const;
};

}  // namespace geometry