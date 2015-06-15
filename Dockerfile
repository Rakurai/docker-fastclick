###
# dpdk image built using phusion/baseimage, refer to instructions for running daemons
###

FROM rakurai/dpdk:2.0.0

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update && apt-get install -y \
  git \
  g++

ENV CLICK_SRC /usr/src/fastclick
RUN curl -sSL -o fastclick.zip https://github.com/MappaM/click/archive/master.zip \
  && unzip fastclick.zip -q -d /usr/src \
  && mv /usr/src/click-master ${CLICK_SRC}

#RUN git clone https://github.com/MappaM/click.git
#WORKDIR click

RUN cd ${CLICK_SRC} 
  && ./configure \
    --enable-multithread \
    --disable-linuxmodule \
    --enable-intel-cpu \
    --enable-user-multithread \
    --verbose \
    CFLAGS="-g -O3" \
    CXXFLAGS="-g -std=gnu++11 -O3" \
    --disable-dynamic-linking \
    --enable-poll \
    --enable-bound-port-transfer \
    --enable-dpdk \
    --enable-batch \
    --with-netmap=no \
    --enable-zerocopy \
    --disable-dpdk-pools \
  && make userlevel

#ENTRYPOINT ["tools/setup.sh"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
