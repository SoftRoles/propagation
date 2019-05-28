#include <exception>
#include <iostream>
#include <string>
#include <propagation/include/pathloss.hpp>
#include <rapidjson/document.h>

int main(int argc, char **argv) {
  static const char* kTypeNames[] =
  { "Null", "False", "True", "Object", "Array", "String", "Number" };
  std::string input;
  rapidjson::Document document;
  while (true) {
    std::getline(std::cin, input);
    document.Parse(input.c_str());
    std::cout << document.IsObject() << "\n" << std::flush;
    if(document.IsObject() &&
        document.HasMember("freq") && document["freq"].IsNumber() &&
        document.HasMember("dist") && document["dist"].IsNumber()) {
      std::cout << softroles::propagation::pathloss(
                  document["freq"].GetDouble(),
                  document["dist"].GetDouble()) << std::endl;
      //for (auto& m : document.GetObject())
      //printf("Type of member %s is %s\n",
      //     m.name.GetString(), kTypeNames[m.value.GetType()]);
    }
  }

  return 0;
}
