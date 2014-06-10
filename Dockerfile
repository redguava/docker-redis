FROM redguava/centos

RUN yum install -y gcc
RUN \
  cd /tmp && \
  curl -o redis-stable.tar.gz http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  cd deps && \
  make hiredis jemalloc linenoise lua && \
  cd .. && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable*
ADD redis.conf /etc/redis/redis.conf
ADD sentinel.conf /etc/redis/sentinel.conf

VOLUME ["/var/redis"]
WORKDIR /var/redis

CMD ["redis-server", "/etc/redis/redis.conf"]
EXPOSE 6379
