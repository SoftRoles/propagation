c++ -c -Wall -Werror -fpic src/fspl.cpp
c++ -shared -o libfspl.so fspl.o
cp libfspl.so /usr/local/lib
ldconfig
mkdir -p /usr/local/include/softroles/propagation
cp src/fspl.hpp /usr/local/include/softroles/propagation/
c++ -Wall -o test/fspl test/fspl.cpp -lfspl
echo "HEY"
c++ -Wall -o /usr/local/bin/fspl src/fspl_bash.cpp -lfspl
test/fspl
rm *.so
rm *.o
