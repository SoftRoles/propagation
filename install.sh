#!/usr/bin/bash

# compile
c++ -c -Wall -Werror -fpic src/pathloss.cpp
c++ -c -Wall -Werror -fpic src/radiohorizon.cpp

# test
c++ -Wall -o test/pathloss test/pathloss.cpp pathloss.o
c++ -Wall -o test/radiohorizon test/radiohorizon.cpp radiohorizon.o
test/pathloss
test/radiohorizon

# create lib
c++ -shared -o libpathloss.so pathloss.o
c++ -shared -o libradiohorizon.so radiohorizon.o

# install
mv libpathloss.so /usr/local/lib
mv libradiohorizon.so /usr/local/lib
ldconfig
mkdir -p /usr/local/include/softroles/propagation
cp include/pathloss.hpp /usr/local/include/softroles/propagation/
cp include/radiohorizon.hpp /usr/local/include/softroles/propagation/

# generate bash script
c++ -o /usr/local/bin/pathloss src/pathloss.bin.cpp -lpathloss
c++ -o /usr/local/bin/radiohorizon src/radiohorizon.bin.cpp -lradiohorizon


# create service
c++ --std=c++11 src/pathloss.service.cpp \
  -o /usr/local/bin/pathloss.service \
  -lpthread -lmongocxx -lbsoncxx -lpathloss
c++ --std=c++11 src/radiohorizon.service.cpp \
  -o /usr/local/bin/radiohorizon.service \
  -lpthread -lmongocxx -lbsoncxx -lradiohorizon
sed s/\<user\>/`whoami`/g template.service > pathloss.service
sed s/\<user\>/`whoami`/g template.service > radiohorizon.service
sed -i s/\<func\>/pathloss/g pathloss.service
sed -i s/\<func\>/radiohorizon/g radiohorizon.service
mv pathloss.service /etc/systemd/system
mv radiohorizon.service /etc/systemd/system
systemctl daemon-reload
systemctl restart pathloss
systemctl restart radiohorizon
systemctl enable pathloss
systemctl enable radiohorizon

# clean
rm pathloss.o
rm radiohorizon.o
