# piarmy-resque

docker build -t mattwiater/piarmy-resque . && \
	docker push mattwiater/piarmy-resque

docker build -t mattwiater/piarmy-resque . && \
  docker run -it --rm  -v /home/pi/images/piarmy-resque-stack/resque/containerFiles:/home/resque/www -p 3000:3000 -e REDIS_DB="piarmy01:6379" --name=piarmy-resque mattwiater/piarmy-resque /bin/bash

# Enter running container
docker exec -it $(docker ps | grep piarmy-resque | awk '{print $1}') /bin/bash

# lambda tests

source ~/.rvm/scripts/rvm && ruby app.rb

# Job: 30.times { |count| Resque.enqueue(Lambda) }

# Internal Test

Instances: Time (seconds)
1: 87.20 
2: 40.01
3: 29.42
4: 24.06

# Scaling timing: 0.75 interval
J# |Q#1|Q#2|Q#3|Q#4

10 |16 |22 |41 |xxx
20 |29 |42 |83 |xxx
30 |43 |64 |xxx|xxx
40 |57 |84 |xxx|xxx
50 |71 |99 |xxx|xxx
60 |85 |xxx|xxx|xxx
70 |95 |xxx|xxx|xxx

T  |287|147|97|77

# Manual watch and scale

j# |s#|q# |@seconds
0  |1 |0  |0
10 |2 |15 |11
20 |3 |29 |22
30 |4 |56 |42

T 100s