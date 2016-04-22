FROM codenvy/cpp

RUN sudo dpkg --add-architecture i386

RUN sudo apt-get -y remove modemmanager
RUN sudo apt-get -y update
RUN sudo apt-get -y install dos2unix build-essential ccache python-lxml screen
# Base packages
RUN sudo apt-get -y install gawk make git arduino-core curl wget
# SITL packages
RUN sudo wget -nv http://ftp.uk.debian.org/debian/pool/main/w/wxwidgets2.8/python-wxgtk2.8_2.8.12.1-12_amd64.deb
RUN sudo dpkg -i --force-all python-wxgtk2.8_2.8.12.1-12_amd64.deb
RUN sudo apt-get -f -y install
RUN sudo apt-get -y install g++ python-pip python-matplotlib python-serial python-scipy python-opencv python-numpy python-empy python-pyparsing ccache
# PX4 packages
RUN sudo apt-get -y install python-serial python-argparse openocd flex bison libncurses5-dev autoconf texinfo build-essential libftdi-dev libtool zlib1g-dev zip genromfs
# Ubuntu64 packages
RUN sudo apt-get -y install libc6:i386 libgcc1:i386 gcc-4.9-base:i386 libstdc++5:i386 libstdc++6:i386

# Python packages
RUN sudo apt-get -y remove python-pip
RUN sudo easy_install pip
RUN sudo pip -q install pymavlink MAVProxy droneapi
RUN sudo pip install catkin_pkg

# Install ARM
# COPY scripts/install_arm.sh /scripts/
# RUN /scripts/install_arm.sh
ENV ARM_ROOT="gcc-arm-none-eabi-4_9-2015q3"
ENV ARM_TARBALL="$ARM_ROOT-20150921-linux.tar.bz2"
ENV ARM_TARBALL_URL="http://firmware.ardupilot.org/Tools/PX4-tools/$ARM_TARBALL"
RUN cd /opt && sudo wget -nv $ARM_TARBALL_URL && sudo tar xjf ${ARM_TARBALL} && sudo rm ${ARM_TARBALL}
RUN echo "export PATH=/opt/$ARM_ROOT/bin:\$PATH" >> $HOME/.profile

# build JSB sim
# COPY scripts/jsb_sim_build.sh /scripts/
# RUN /scripts/jsb_sim_build.sh
RUN sudo apt-get install -y libtool-bin automake autoconf libexpat1-dev
RUN git clone git://github.com/tridge/jsbsim.git
RUN cd jsbsim && ./autogen.sh && make -j2 && sudo make install

COPY screenrc $HOME/.screenrc
