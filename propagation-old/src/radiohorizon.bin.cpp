#include <exception>
#include <iostream>
#include <args.hxx>
#include <softroles/propagation/radiohorizon.hpp>

int main(int argc, char **argv) {
  args::ArgumentParser parser("horizon distance for radio waves.", "");
  args::HelpFlag help(parser, "help", "Displays this help menu", {'h', "help"});
  args::Group group1(parser, "flag arguments:", args::Group::Validators::AllOrNone);
  args::ValueFlag<float> height1(group1, "height", "antenna height in [m]", {'h', "height"});
  args::Group group2(parser, "positional arguments:", args::Group::Validators::AllOrNone);
  args::Positional<float> height2(group2, "height", "");
  try
  {
    parser.ParseCLI(argc, argv);
  }
  catch (args::Help)
  {
    std::cout << parser;
    return 0;
  }
  catch (args::ParseError e)
  {
    std::cerr << e.what() << std::endl;
    std::cerr << parser;
    return 1;
  }
  catch (args::ValidationError e)
  {
    std::cerr << "Usage:" << e.what() << std::endl;
    std::cerr << parser;
    return 1;
  }

  if(height1) {
    std::cout << softroles::propagation::radiohorizon(args::get(height1)) << std::endl;
  }
  else if(height2) {
    std::cout << softroles::propagation::radiohorizon(args::get(height2)) << std::endl;
  }
  else {
    std::cerr << parser;
  }
  return 0;
}
