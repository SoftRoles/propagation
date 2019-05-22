# compile
c++ -c -Wall -Werror -fpic src/pathloss.cpp
# create lib
c++ -shared -o libpathloss.so pathloss.o
