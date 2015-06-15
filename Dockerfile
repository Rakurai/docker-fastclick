###
# dpdk image built using phusion/baseimage, refer to instructions for running daemons
###

FROM rakurai/dpdk:2.0.0-onbuild

RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  g++ \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV CLICK_SRC /usr/src/fastclick

RUN curl -ksSL http://github.com/MappaM/click/archive/master.tar.gz | tar -xz; \
  mv click-master ${CLICK_SRC}

RUN . ${RTE_SDK}/dpdk_env.sh; \
  cd ${CLICK_SRC} \
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
  && make install-userlevel \
  && make clean

CMD ["click"]
