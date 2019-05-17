#include <iostream>
#include <cassert>
#include <cmath>
#include "../src/pathloss.hpp"

#define EPSILON 0.01

bool isequal(float a, float b){
  return std::fabs(a-b) < EPSILON;
}

int main(){

  std::cout << "Testing propagation::pathloss ...";
  assert(isequal(softroles::propagation::pathloss(2, 3), 48.00));
  std::cout << " OK" << std::endl;
  return 0;;
}

