#!/bin/bash
sudo apt update
sudo apt install -y redis-server
sudo systemctl enable redis-server
sudo sed -i 's/bind 127\.0\.0\.1 ::1/bind 0\.0\.0\.0/g' /etc/redis/redis.conf
sudo sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf
sudo bash -c 'echo "maxmemory 512mb" >> /etc/redis/redis.conf'
sudo bash -c 'echo "maxmemory-policy allkeys-lru" >> /etc/redis/redis.conf'
sudo systemctl restart redis-server