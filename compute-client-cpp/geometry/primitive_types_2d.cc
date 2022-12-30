#include "geometry/primitive_types_2d.h"

#include "absl/strings/str_cat.h"

namespace geometry {

const char* const kComma = ",";

std::string Point2D::ToCompactString() const {
  return absl::StrCat(x, kComma, y);
}

std::string Rect2D::ToCompactString() const {
  return absl::StrCat(xstart, kComma, ystart, kComma,
      xend, kComma, yend);
}

std::string IntRect2D::ToCompactString() const {
  return absl::StrCat(xstart, kComma, ystart, kComma,
      xend, kComma, yend);
}

}  // namespace geometry