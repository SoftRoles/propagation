#include <exception>
#include <math.h>
#include "../include/radiohorizon.hpp"

float softroles::propagation::radiohorizon(float h) {
  try {
    return 4.12 * std::sqrt(h);
  }
  catch(std::exception& e) {
    throw;
  }
}
