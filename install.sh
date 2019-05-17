# compile
c++ -c -Wall -Werror -fpic src/pathloss.cpp
# create lib
c++ -shared -o libpathloss.so pathloss.o
cp libpathloss.so /usr/local/lib
ldconfig
# add source
mkdir -p /usr/local/include/softroles/propagation
cp src/pathloss.hpp /usr/local/include/softroles/propagation/
# test
c++ -Wall -o test/pathloss test/pathloss.cpp -lpathloss
test/pathloss
# generate bash script
c++ -Wall -o /usr/local/bin/pathloss src/bash/pathloss.cpp -lpathloss
c++ --std=c++11 src/mongodb/pathloss.cpp -o main -lmongocxx -lbsoncxx
# clean
rm *.so
rm *.o
