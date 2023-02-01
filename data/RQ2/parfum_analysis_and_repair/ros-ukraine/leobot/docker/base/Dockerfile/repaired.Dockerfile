FROM shadowrobot/build-tools:xenial-kinetic-ide

MAINTAINER "ROS Ukraine Community"

LABEL Description="This ROS Kinetic image containes all dependencies for LeoBot with IDEs" Vendor="ROS Ukraine" Version="1.0"

ENV remote_deploy_script="https://raw.githubusercontent.com/shadow-robot/sr-build-tools/$toolset_branch/ansible/deploy.sh"

RUN set -x && \

    echo "Upgrading Gazebo 7 to latest release" && \
    apt-get update && \
    echo https://packages.osrfoundation.org/gazebo.key /u u t -stable `lsb_ el \
    wget http://pa ka \
    apt-get update && \
    apt-get remove -y gazebo7 & \
    apt-get install -y gazebo7 &  \

    echo "Loading gazebo models" && \
    /home/$MY_USERNAME/sr-bui d- \
    chown -R $MY_USERNAME:$MY_USERNAME /h \

    echo "Backing up .bashrc" && \
    cp /home/$MY_USERNAME/. as \

    echo "Running one-liner" && \
    wget -O /tmp/oneliner "$( echo "$r mo \
    chmod 755 /tmp/oneliner && \
    gosu $MY_USERNAME /tmp/oneliner -o ros-ukr in \

    echo "Restori g \
    cp /tmp/.bashrc /home/$MY_USERNAME && \

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/bin/terminator"]
