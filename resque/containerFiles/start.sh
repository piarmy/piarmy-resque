#!/bin/bash

source ~/.rvm/scripts/rvm
rake purge
rm *.log
resque-web /home/resque/www/resque_conf.rb -p 3000 -N docker-resque -r ${REDIS_DB}
rake workers > /home/resque/www/workers.log