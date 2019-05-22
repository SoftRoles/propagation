# create service
c++ --std=c++11 service/pathloss.cpp -o /usr/local/bin/pathloss.service -lpthread -lmongocxx -lbsoncxx -lpathloss
sed s/\<user\>/`whoami`/g template.service > pathloss.service
sed -i s/\<func\>/pathloss/g pathloss.service
mv pathloss.service /etc/systemd/system
systemctl daemon-reload
systemctl restart pathloss
systemctl enable pathloss
# clean
