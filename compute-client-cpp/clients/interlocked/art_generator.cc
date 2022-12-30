#include "clients/interlocked/art_generator.h"

#include <algorithm>
#include <random>
#include <unordered_set>
#include <vector>

#include "absl/log/check.h"
#include "absl/log/log.h"
#include "absl/random/random.h"
#include "absl/random/uniform_int_distribution.h"
#include "absl/strings/str_format.h"
#include "geometry/primitive_types_2d.h"

#include "clients/interlocked/art_base.h"
#include "io/sketch_client_socket.h"

namespace genart::interlocked {
namespace {

const int32_t kWidth = 64;
const int32_t kHeight = 64;
const int32_t kMaxSize = 42; //9;
const int32_t kDesiredNumPieces = 6; // 32;
const int32_t kDesiredSolutions = 10;
const int32_t kThick = 2;


struct PieceInfo {
  int xstart = 0;
  int ystart = 0;
  int xend = 0;
  int yend = 0;

  int32_t Hash() const {
    return (xstart << 16 | ystart) % 131;
  }

  std::string DebugString() const {
    return absl::StrFormat("(%d,%d)-(%d,%d)", xstart, ystart, xend, yend);
  }

  int Contains3Way(int x0, int y0, int x1, int y1) const {
    if ((x0 > xstart + kThick) &&  (x1 < xend - kThick) &&
      (y0 > ystart + kThick) &&  (y1 < yend - kThick)) return 1;
    if ((x1 < xstart - 1) || (x0 > xend + 1) ||
      (y1 < ystart - 1) || (y0 > yend + 1)) return -1;
    return 0;
  }

  // Returns -1 if not at all compatible.
  int64_t CompatibilityScore(const PieceInfo& p) const {
    int c0 = Contains3Way(p.xstart, p.ystart, p.xstart + kThick, p.ystart + kThick);
    int c1 = Contains3Way(p.xend - kThick, p.ystart, p.xend, p.ystart + kThick);
    int c2 = Contains3Way(p.xstart, p.yend - kThick, p.xstart + kThick, p.yend);
    int c3 = Contains3Way(p.xend - kThick, p.yend - kThick, p.xend, p.yend);

    int num_internal_corners = 0;
    int num_external_corners = 0;
    for (int c : {c0, c1, c2, c3}) {
      if (c == 1) ++num_internal_corners;
      if (c == -1) ++num_external_corners;
    }
    if ((num_internal_corners + num_external_corners) < 4) return -1;
    switch (num_internal_corners) {
      case 0: return 1;
      case 1: return 2;
      case 2: return 3;
      case 3: return 0;
    }
    return 0;
  }
};

class BoardState {
 public:
  BoardState();

  void SetSolutionHandler(std::function<void(int64_t score)>&& func) {
    solution_handler_ = std::move(func);
  }

  void SolveRecursive(int remaining_depth, int64_t score);

  void CopyState(std::vector<PieceInfo>& pieces) const {
    pieces.assign(pieces_.cbegin(), pieces_.cend());
  }

  void SetEnabled(bool enabled) { enabled_ = enabled; }

 private:
  std::vector<PieceInfo> pieces_;

  // Called upon each comp[lete solution.]
  std::function<void(int64_t score)> solution_handler_;

  bool enabled_{false};

  std::vector<std::pair<int, int>> indices_ij_;

  // Random number generation utility.
  absl::BitGen bitgen_;
  absl::uniform_int_distribution<int8_t> uniform5_; //(0, 63);
};

BoardState::BoardState() : uniform5_(kMaxSize, kMaxSize) {
  pieces_.reserve(64);

  const int limit = 64 - kMaxSize;
  indices_ij_.reserve(limit * limit);
  for (int i = 0; i < limit; ++i) {
    for (int j = 0; j < limit; ++j) {
      indices_ij_.emplace_back(i, j);
    }
  }
  std::sort(indices_ij_.begin(), indices_ij_.end(), [](const auto& a, const auto& b) {
    int mina = std::min(a.first, limit - a.first) + std::min(a.second, limit - a.second);
    int minb = std::min(b.first, limit - b.first) + std::min(b.second, limit - b.second);
    // return mina < minb;
    return (a.first + a.second) < (b.first + b.second);
  });
  // std::shuffle(indices_ij_.begin(), indices_ij_.end(), bitgen_);
}

void BoardState::SolveRecursive(int remaining_depth, int64_t score) {
  if (!enabled_) return;
  if (remaining_depth == 0) {
    if (solution_handler_) solution_handler_(score);
    return;
  }
  PieceInfo piece;
  std::unordered_set<int32_t> seen_posns;
  bool found_config = false;

  int64_t current_score = 1;
  for (const auto& [i, j] : indices_ij_) {
    piece.xstart = i;
    piece.ystart = j;
    piece.xend = piece.xstart + uniform5_(bitgen_);
    piece.yend = piece.ystart + uniform5_(bitgen_);
    bool incompatible = false;
    int64_t current_score = 1;
    for (const auto& q : pieces_) {
      int64_t piece_score = q.CompatibilityScore(piece);
      if (piece_score <= 0) {
        incompatible = true; break;
      }
      current_score = std::max(current_score, piece_score);
    }
    if (incompatible) continue;
    // Recurse down.
    pieces_.push_back(piece);
    SolveRecursive(remaining_depth - 1, current_score * score);
    pieces_.pop_back();
  }
}

}  // namespace

//------------------------------------------------------------------------------

void RunArtGeneration() {
  LOG(INFO) << "Started art generation (INTERLOCKED) ..";
  BoardState board;
  std::vector<PieceInfo> pieces;
  int64_t num_found_solutions = 0;
  int64_t best_score = 0;
  board.SetSolutionHandler([&](int64_t score) {
    if (score > best_score) {
      best_score = score;
      board.CopyState(pieces);
    }
    ++num_found_solutions;
    if (num_found_solutions % 10000L == 0) {
      LOG(INFO) << "Num solutions .... " << num_found_solutions
        << ", best_score: " << best_score;
    }
    if (num_found_solutions > 10L) {
      board.SetEnabled(false);
    }
  });
  board.SetEnabled(true);
  board.SolveRecursive(kDesiredNumPieces, 1L);
  board.SetEnabled(false);

  LOG(INFO) << "Solved - << Best Score >>> .... " << best_score;

  // Convert into art piece.
  {
    ArtPiece art;
    for (const PieceInfo& p : pieces) {
      geometry::IntRect2D bound = {p.xstart, p.ystart, p.xend, p.yend};
      geometry::IntRect2D gap = {p.xstart + kThick, p.ystart + kThick, p.xend - kThick, p.yend - kThick};
      auto block = ArtPiece::Block{
        .bound = bound,
        .gaps = {gap},
      };
      art.AddBlock(std::move(block));
    }
    LOG(INFO) << "ART === " << art.ToJsonString();
    // Send the data to sketch.
    genart::SketchClientSocket client;
    const std::string message = art.ToJsonString();
    client.SendData(message);
  }
}

}  // namespace genart::interlocked