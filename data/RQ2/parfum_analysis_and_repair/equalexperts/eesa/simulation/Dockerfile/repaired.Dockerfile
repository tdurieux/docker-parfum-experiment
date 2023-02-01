FROM ubuntu:18.10
LABEL maintainer="tsquires@equalexperts.com"
RUN apt-get update
RUN apt-get -y --no-install-recommends install python && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y autoremove
RUN apt-get -y clean
RUN pip install --no-cache-dir MAVProxy
ENV LOCATION ICEL
ENV UDP_HOST docker.for.mac.localhost
ENV FG_PORT 5503
# ENV START_ALTITUDE 30000
RUN cd ~; git clone https://github.com/ArduPilot/ardupilot.git; cd ardupilot; git submodule update --init --recursive
RUN cd ~/ardupilot; Tools/scripts/install-prereqs-ubuntu.sh -y; . ~/.profile
COPY locations.txt /root/ardupilot/Tools/autotest/locations.txt
COPY sim_eesa.py /root/ardupilot/Tools/autotest/sim_eesa.py
RUN chmod a+x /root/ardupilot/Tools/autotest/sim_eesa.py
COPY on_ground.patch /root/ardupilot/sitl_alt.patch
RUN cd /root/ardupilot; git apply sitl_alt.patch
COPY runsim.patch /root/ardupilot/runsim.patch
RUN cd /root/ardupilot; git apply runsim.patch
COPY fgout.patch /root/ardupilot/fgout.patch
RUN cd /root/ardupilot; git apply fgout.patch
WORKDIR /root/ardupilot/ArduPlane
RUN /root/ardupilot/Tools/autotest/sim_eesa.py --build_only
RUN cd ~; git clone git://jsbsim.git.sourceforge.net/gitroot/jsbsim/jsbsim
RUN cd ~/jsbsim && mkdir build && cd build && cmake .. && make && make install
EXPOSE 9000:9000/udp
EXPOSE 5503:5503/udp
WORKDIR /root/ardupilot/ArduPlane
#ENTRYPOINT /root/ardupilot/Tools/autotest/sim_eesa.py -f jsbsim --no-rebuild --out $UDP_HOST:9000 -L $LOCATION
ENTRYPOINT /root/ardupilot/Tools/autotest/sim_eesa.py --no-rebuild --out $UDP_HOST:9000 -L $LOCATION
