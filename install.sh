#!/bin/bash

sources=(pathloss radiohorizon)

# compile
for source in "${sources[@]}"; do 
  c++ -c -Wall -Werror -fpic "src/$source.cpp"
done

# test
for source in "${sources[@]}"; do 
  c++ -Wall -o test/$source test/$source.cpp $source.o
  test/$source
done

# create lib
for source in "${sources[@]}"; do 
  c++ -shared -o lib$source.so $source.o
done

# install
for source in "${sources[@]}"; do 
  mv lib$source.so /usr/local/lib
  ldconfig
  mkdir -p /usr/local/include/softroles/propagation
  cp include/$source.hpp /usr/local/include/softroles/propagation/
done

# generate bash script
for source in "${sources[@]}"; do 
  c++ -o /usr/local/bin/$source src/$source.bin.cpp -l$source
done

# create service
for source in "${sources[@]}"; do 
  c++ --std=c++11 src/$source.service.cpp \
    -o /usr/local/bin/$source.service \
    -lpthread -lmongocxx -lbsoncxx -l$source
  sed s/\<user\>/`whoami`/g template.service > $source.service
  sed -i s/\<func\>/$source/g $source.service
  mv $source.service /etc/systemd/system
  systemctl daemon-reload
  systemctl restart $source
  systemctl enable $source
done

# clean
for source in "${sources[@]}"; do 
  rm $source.o
  rm test/$source
done
