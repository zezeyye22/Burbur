FROM alpine:latest
LABEL maintainer="Khumble <By@GDO>"

# Setup environment
RUN apk update \
  && apk upgrade \
  && apk add murmur=1.3.4-r4 \
  && rm -rf /var/cache/apk/*

# Add data dir
RUN mkdir /datav1 \
  && chown murmur:murmur /datav1

# Copy config to data dir
RUN (false | cp -i /etc/murmur.ini /datav1/config.ini) \
  && sed -i "s/database=.*/database=\/data\/murmur.sqlite/" /datav1/config.ini \
  && sed -i "s/logfile=.*/logfile=\/data\/murmur.log/" /datav1/config.ini \
  && chown murmur:murmur /datav1/config.ini

# Set data dir as persistent volume
VOLUME /datav1

# Set user

# Expose server port TCP/UDP
EXPOSE 64738/tcp 64738/udp

# Start server
ENTRYPOINT [ "/usr/bin/murmurd", "-ini", "/datav1/config.ini", "-v", "-fg" ]
