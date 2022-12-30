#pragma once

#include <string>
#include <vector>

#include "geometry/primitive_types_2d.h"

namespace genart {

class ArtPiece {
 public:
  // Type to describe a single block.
  struct Block {
    geometry::IntRect2D bound;
    std::vector<geometry::IntRect2D> gaps;
  };

  std::string ToJsonString() const;

  void FillDummyValues();

  void AddBlock(Block&& block) {
    blocks_.push_back(std::move(block));
  }

 private:
  //geometry::IntRect2D bound_;
  //std::vector<geometry::IntRect2D> gaps_;
  std::vector<Block> blocks_;
  
};

}  // namespace genart
