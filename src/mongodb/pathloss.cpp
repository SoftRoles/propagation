#include <iostream>
#include <exception>

#include <bsoncxx/builder/basic/document.hpp>
#include <bsoncxx/builder/basic/kvp.hpp>
#include <bsoncxx/json.hpp>
#include <bsoncxx/string/to_string.hpp>
#include <mongocxx/change_stream.hpp>
#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>
#include <mongocxx/pool.hpp>
#include <mongocxx/uri.hpp>

namespace {

std::string get_server_version(const mongocxx::client& client) {
  bsoncxx::builder::basic::document server_status{};
  server_status.append(bsoncxx::builder::basic::kvp("serverStatus", 1));
  bsoncxx::document::value output = client["test"].run_command(server_status.extract());

  return bsoncxx::string::to_string(output.view()["version"].get_utf8().value);
}

void watch_until(const mongocxx::client& client,
                 const std::chrono::time_point<std::chrono::system_clock> end) {
  mongocxx::options::change_stream options;
  // Wait up to 1 second before polling again.
}
}

int main(int argc, char **argv) {
  mongocxx::instance inst {};
  mongocxx::pool pool{mongocxx::uri{}};

  try {
    auto entry = pool.acquire();

    if (get_server_version(*entry) < "3.6") {
      std::cerr << "Change streams are only supported on Mongo versions >= 3.6." << std::endl;
      // CXX-1548: Should return EXIT_FAILURE, but Travis is currently running Mongo 3.4
      return EXIT_SUCCESS;
    }

    mongocxx::options::change_stream options;
    const std::chrono::milliseconds await_time{1000};
    options.max_await_time(await_time);

    auto collection = (*entry)["modules"]["propagation"];
    mongocxx::change_stream stream = collection.watch(options);

    while (true) {
      for (const auto& event : stream) {
        std::cout << bsoncxx::to_json(event) << std::endl;
      }
    }

    return EXIT_SUCCESS;
  } catch (const std::exception& exception) {
    std::cerr << "Caught exception \"" << exception.what() << "\"" << std::endl;
  } catch (...) {
    std::cerr << "Caught unknown exception type" << std::endl;
  }

  return EXIT_FAILURE;
}
