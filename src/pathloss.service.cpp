#include <iostream>
#include <exception>
#include <chrono>
#include <thread>
#include <future>
#include <softroles/propagation/pathloss.hpp>

#include <bsoncxx/builder/basic/document.hpp>
#include <bsoncxx/builder/basic/kvp.hpp>
#include <bsoncxx/json.hpp>
#include <bsoncxx/oid.hpp>
#include <bsoncxx/string/to_string.hpp>
#include <mongocxx/change_stream.hpp>
#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>
#include <mongocxx/pool.hpp>
#include <mongocxx/uri.hpp>

using::bsoncxx::builder::basic::kvp;
using::bsoncxx::builder::basic::make_document;

namespace {

std::string get_server_version(const mongocxx::client& client) {
  bsoncxx::builder::basic::document server_status{};
  server_status.append(bsoncxx::builder::basic::kvp("serverStatus", 1));
  bsoncxx::document::value output = client["test"].run_command(server_status.extract());

  return bsoncxx::string::to_string(output.view()["version"].get_utf8().value);
}

}

void func(mongocxx::collection collection, const bsoncxx::document::element& doc) {
  auto id = doc["_id"].get_oid().value.to_string();
  std::string error;
  float freq, dist;
  try {
    freq = doc["args"]["freq"].get_double().value;
    dist = doc["args"]["dist"].get_double().value;
  } catch(const std::exception& e) {
    error = e.what();
    collection.update_one(make_document(kvp("_id", bsoncxx::oid(id))),
                          make_document(kvp("$set", make_document(kvp("error",make_document(kvp("stage", "arg parse"), kvp("message", error)))))));
  }
  try {
    auto start = std::chrono::high_resolution_clock::now();
    auto result = softroles::propagation::pathloss(freq, dist);
    auto stop = std::chrono::high_resolution_clock::now();
    auto duration = static_cast<int>(std::chrono::duration_cast<std::chrono::microseconds>(stop-start).count());
    collection.update_one(make_document(kvp("_id", bsoncxx::oid(id))),
                          make_document(kvp("$set", make_document(kvp("output",result),kvp("duration",duration)))));
  } catch(const std::exception& e) {
    error = e.what();
    collection.update_one(make_document(kvp("_id", bsoncxx::oid(id))),
                          make_document(kvp("$set", make_document(kvp("error",make_document(kvp("stage", "calculate"), kvp("message", error)))))));
  }

}

int main(int argc, char **argv) {
  try {
    mongocxx::instance inst {};
    mongocxx::pool pool{mongocxx::uri{}};

    auto entry = pool.acquire();

    if (get_server_version(*entry) < "3.6") {
      std::cerr << "Change streams are only supported on Mongo versions >= 3.6." << std::endl;
      // CXX-1548: Should return EXIT_FAILURE, but Travis is currently running Mongo 3.4
      return EXIT_SUCCESS;
    }

    mongocxx::options::change_stream options;
    const std::chrono::milliseconds await_time{1000};
    options.max_await_time(await_time);
    options.full_document("updateLookup");

    auto collection = (*entry)["modules"]["propagation"];
    mongocxx::change_stream stream = collection.watch(options);

    while (true) {
      for (const auto& event : stream) {
        //std::cout << bsoncxx::to_json(event) << std::endl;
        auto operation = event["operationType"].get_utf8().value;
        if(operation.compare("insert") == 0) {
          auto doc = event["fullDocument"];
          auto function = doc["function"].get_utf8().value;
          //std::cout << collection << std::endl;
          if(function.compare("pathloss") == 0) {
            std::future<void> async = std::async(func, collection, doc);
          }
        }
      }
    }

  } catch (const std::exception& exception) {
    std::cerr << "Caught exception \"" << exception.what() << "\"" << std::endl;
  } catch (...) {
    std::cerr << "Caught unknown exception type" << std::endl;
  }
  return EXIT_SUCCESS;
}
