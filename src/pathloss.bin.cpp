#include <exception>
#include <iostream>
#include <args.hxx>
#include <softroles/propagation/pathloss.hpp>

int main(int argc, char **argv) {
  args::ArgumentParser parser("radio wave propagation path loss", "");
  args::HelpFlag help(parser, "help", "displays this help menu", {'h', "help"});
  args::Group group1(parser, "flag arguments:", args::Group::Validators::AllOrNone);
  args::ValueFlag<float> freq1(group1, "freq", "frequency in MHz", {'f', "freq"});
  args::ValueFlag<float> dist1(group1, "dist", "distance in km", {'d', "dist"});
  args::Group group2(parser, "positional arguments:", args::Group::Validators::AllOrNone);
  args::Positional<float> freq2(group2, "freq", "");
  args::Positional<float> dist2(group2, "dist", "");
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

  if(freq2 && dist2) {
    std::cout << softroles::propagation::pathloss(args::get(freq2), args::get(dist2)) << std::endl;
  }
  else if(freq1 && dist1) {
    std::cout << softroles::propagation::pathloss(args::get(freq1), args::get(dist1)) << std::endl;
  }
  else {
    std::cerr << parser;
  }
  return 0;
}
