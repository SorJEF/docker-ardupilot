FROM ubuntu:14.04

RUN dpkg --add-architecture i386

RUN apt-get -y remove modemmanager
RUN apt-get -y update
RUN apt-get -y install dos2unix g++-4.7 ccache python-lxml screen
# Base packages
RUN apt-get -y install gawk make git arduino-core curl wget
# SITL packages
RUN apt-get -y install g++ python-pip python-matplotlib python-serial python-wxgtk2.8 python-scipy python-opencv python-numpy python-empy python-pyparsing ccache
# PX4 packages
RUN apt-get -y install python-serial python-argparse openocd flex bison libncurses5-dev autoconf texinfo build-essential libftdi-dev libtool zlib1g-dev zip genromfs
# Ubuntu64 packages
RUN apt-get -y install libc6:i386 libgcc1:i386 gcc-4.9-base:i386 libstdc++5:i386 libstdc++6:i386

# Python packages
RUN pip -q install pymavlink MAVProxy droneapi
RUN pip install catkin_pkg

# Install ARM
# COPY scripts/install_arm.sh /scripts/
# RUN /scripts/install_arm.sh
ENV ARM_ROOT="gcc-arm-none-eabi-4_9-2015q3"
ENV ARM_TARBALL="$ARM_ROOT-20150921-linux.tar.bz2"
ENV ARM_TARBALL_URL="http://firmware.ardupilot.org/Tools/PX4-tools/$ARM_TARBALL"
RUN cd /opt && wget -nv $ARM_TARBALL_URL && tar xjf ${ARM_TARBALL} && rm ${ARM_TARBALL}
RUN echo "export PATH=/opt/$ARM_ROOT/bin:\$PATH" >> $HOME/.profile

# build JSB sim
# COPY scripts/jsb_sim_build.sh /scripts/
# RUN /scripts/jsb_sim_build.sh
RUN apt-get install -y libtool automake autoconf libexpat1-dev
RUN git clone git://github.com/tridge/jsbsim.git
RUN cd jsbsim && ./autogen.sh && make -j2 && make install

COPY screenrc $HOME/.screenrc
