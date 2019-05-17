#include <exception>
#include <math.h>
#include "pathloss.hpp"

float softroles::propagation::pathloss(float f, float d) {
  try {
    return 32.44 + 20*std::log10(f*d);
  }
  catch(std::exception& e) {
    throw;
  }
}
