#include <exception>
#include <iostream>
#include <args.hxx>
#include <softroles/propagation/radiohorizon.hpp>

int main(int argc, char **argv) {
  args::ArgumentParser parser("Radio wave propagation path loss.", "Ref: \n");
  args::HelpFlag help(parser, "help", "Displays this help menu", {'h', "help"});
  args::Group group(parser, "Floating number arguments:", args::Group::Validators::All);
  args::Positional<float> height(group, "h", "Antenna height in [m]");
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
    std::cerr << "Usage:" /*<< e.what() */<< std::endl;
    std::cerr << parser;
    return 1;
  }
  std::cout << softroles::propagation::radiohorizon(args::get(height)) << std::endl;

  return 0;
}
