#include <exception>
#include <math.h>
#include "fspl.hpp"

float softroles::propagation::fspl(float f, float d) {
  try {
    return 32.44 + 20*std::log10(f*d);
  }
  catch(std::exception& e) {
    throw;
  }
}
