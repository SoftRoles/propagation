cp libpathloss.so /usr/local/lib
ldconfig
# copy header
mkdir -p /usr/local/include/softroles/propagation
cp include/pathloss.hpp /usr/local/include/softroles/propagation/
