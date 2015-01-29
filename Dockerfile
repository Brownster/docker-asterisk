FROM phusion/baseimage:0.9.15
MAINTAINER Doug Smith <info@laboratoryb.org>
# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

#Change uid & gid to match Unraid
#RUN usermod -u 99 nobody && \
#    usermod -g 100 nobody && \
#    usermod -d /home nobody && \
#    chown -R nobody:users /home

RUN apt-get update -y

RUN apt-get install build-essential wget libssl-dev libncurses5-dev libnewt-dev  libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev tar -y

ENV AUTOBUILD_UNIXTIME 1418234402

# Download asterisk.
# Currently Certified Asterisk 11.6 cert 6.
RUN curl -sf -o /tmp/asterisk.tar.gz -L http://downloads.asterisk.org/pub/telephony/certified-asterisk/certified-asterisk-11.6-current.tar.gz

# gunzip asterisk
RUN mkdir /tmp/asterisk
RUN tar -xzf /tmp/asterisk.tar.gz -C /tmp/asterisk --strip-components=1
WORKDIR /tmp/asterisk

# make asterisk.
ENV rebuild_date 2015-01-29
# Configure
RUN ./configure --libdir=/usr/lib64 1> /dev/null
# Remove the native build option
RUN make menuselect.makeopts
RUN sed -i "s/BUILD_NATIVE//" menuselect.makeopts
# Continue with a standard make.
RUN make 1> /dev/null
RUN make install 1> /dev/null
RUN make samples 1> /dev/null
WORKDIR /

RUN mkdir -p /etc/asterisk
# ADD modules.conf /etc/asterisk/
ADD iax.conf /etc/asterisk/
ADD extensions.conf /etc/asterisk/

CMD asterisk -f
