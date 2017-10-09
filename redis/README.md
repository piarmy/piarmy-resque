# Testing

docker build -t mattwiater/piarmy-redis . && \
  docker push mattwiater/piarmy-redis && \
  docker run -it --rm  -v /home/pi/images/piarmy-redis/containerFiles:/home/redis -p 6379:6379 --name=piarmy-redis mattwiater/piarmy-redis /bin/bash

docker build -t mattwiater/piarmy-redis . && \
  docker run -it --rm  -v /home/pi/images/piarmy-redis/containerFiles:/home/redis/data -p 6379:6379 --name=piarmy-redis mattwiater/piarmy-redis /bin/bash

redis-server --appendonly yes


docker run -it --rm  -v /home/pi/images/piarmy-redis/containerFiles:/home/redis -p 6379:6379 --name=piarmy-redis mattwiater/piarmy-redis /bin/bash

docker run -it --rm  -v /home/pi/images/piarmy-redis/containerFiles:/home/redis -p 6379:6379 --name=piarmy-redis mattwiater/piarmy-redis

docker run -d --rm  -v /home/pi/images/piarmy-redis/containerFiles:/home/redis -p 6379:6379 --name=piarmy-redis mattwiater/piarmy-redis