FROM alpine:edge
LABEL maintainer="Khumble <By@GDO>"

# Setup environment
RUN apk update \
  && apk upgrade \
  && apk add murmur \
  && rm -rf /var/cache/apk/*

# Add data dir
RUN mkdir /data \
  && chown murmur:murmur /data

# Copy config to data dir
RUN (false | cp -i /etc/murmur.ini /data/config.ini) \
  && sed -i "s/database=.*/database=\/data\/murmur.sqlite/" /data/config.ini \
  && sed -i "s/logfile=.*/logfile=\/data\/murmur.log/" /data/config.ini \
  && chown murmur:murmur /data/config.ini

# Set data dir as persistent volume
VOLUME /data

# Set user

# Expose server port TCP/UDP
EXPOSE 64738/tcp 64738/udp

# Start server
ENTRYPOINT [ "/usr/bin/murmurd", "-ini", "/data/config.ini", "-v", "-fg" ]
