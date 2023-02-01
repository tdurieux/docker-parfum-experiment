# Docker file for RoboCup@HomeEducation and MARRtino apps
#
# Latest update
#

FROM iocchi/rchomeedu-1804-melodic:4

# <<< New >>>

# shellinabox arduino

USER root

RUN apt update && \
    apt install --no-install-recommends -y openssl shellinabox arduino arduino-mk netcat && rm -rf /var/lib/apt/lists/*;

ADD config/shellinabox /etc/default/shellinabox

RUN service shellinabox start


USER robot

RUN echo "export MAPSDIR=$HOME/src/stage_environments/maps" >> $HOME/.bashrc

# Trick to disable cache from here
ADD http://worldclockapi.com/api/json/utc/now /tmp/time.tmp

RUN cd $HOME/src/gradient_based_navigation && git pull && \
    cd $HOME/src/modim && git pull && \
    cd $HOME/src/marrtino_apps && git pull && \
    cd $HOME/src/rc-home-edu-learn-ros && git pull

# Compile ROS packages

RUN /bin/bash -ci "cd $HOME/ros/catkin_ws; catkin_make"

RUN echo "Mega2560" > $HOME/.marrtino_machine
RUN echo "MARRtinoMB" > $HOME/.marrtino_motorboard

WORKDIR /home/robot

CMD [ "/bin/bash", "-ci", "/home/robot/src/marrtino_apps/bringup/1-bringup.bash", "-docker" ]

