FROM redis
RUN mkdir /usr/local/etc/redis
COPY ./config /usr/local/etc/redis
RUN apt-get update
RUN apt-get install -y ruby vim wget redis-tools
RUN cd /usr/local/etc/redis
RUN wget -P /usr/local/etc/redis http://download.redis.io/redis-stable/src/redis-trib.rb
RUN chmod +x /usr/local/etc/redis/redis-trib.rb
RUN gem install redis
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]