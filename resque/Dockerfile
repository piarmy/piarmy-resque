FROM resin/rpi-raspbian:jessie

RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get install bzip2 \
  patch libtool bison \
  pkg-config libffi-dev \
  libgmp-dev libreadline6-dev \
  nano gawk g++ gcc make libc6-dev \
  zlib1g-dev libssl-dev libyaml-dev \
  libsqlite3-dev sqlite3 autoconf \
  libgdbm-dev libncurses5-dev automake && \
  adduser --disabled-password --gecos "" resque && \
  adduser resque sudo

USER resque

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
  \curl -L https://get.rvm.io | bash && \
  mkdir /home/resque/www

RUN /bin/bash -l -c "rvm install 2.3.3" && \
  /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

COPY containerFiles /home/resque/www

WORKDIR /home/resque/www

RUN /bin/bash -l -c "source ~/.rvm/scripts/rvm && gem install bundler --no-ri --no-rdoc && bundle install"

EXPOSE 3000

CMD ["bash", "/home/resque/www/start.sh"]