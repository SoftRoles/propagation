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
c++ -o /usr/local/bin/pathloss src/bash/pathloss.cpp -lpathloss
# create service
c++ --std=c++11 src/service/pathloss.cpp -o /usr/local/bin/pathloss.service -lmongocxx -lbsoncxx -lpathloss
sed s/\<user\>/`whoami`/g template.service > pathloss.service
sed -i s/\<func\>/pathloss/g pathloss.service
mv pathloss.service /etc/systemd/system
systemctl daemon-reload
systemctl restart pathloss
# clean
rm *.so
rm *.o
