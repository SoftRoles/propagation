#include <iostream>
#include <cassert>
#include <cmath>
#include "../include/radiohorizon.hpp"

#define EPSILON 0.1

bool isequal(float a, float b){
  return std::fabs(a-b) < EPSILON;
}

int main(){

  std::cout << "Testing propagation::radiohorizon ...";
  assert(isequal(softroles::propagation::radiohorizon(10), 13.0));
  std::cout << " OK" << std::endl;
  return 0;;
}

