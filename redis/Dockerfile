FROM armhf/redis
LABEL maintainer "matt@brightpixel.com"

RUN apt-get update && apt-get -y upgrade && \
  apt-get install -yq \
  sudo bash nano

RUN mkdir /home/redis && \
  chmod -R 777 /home/redis && \
  chown redis:redis /home/redis

#USER redis

WORKDIR /home/redis/

EXPOSE 6379

CMD ["redis-server", "--appendonly", "yes"]