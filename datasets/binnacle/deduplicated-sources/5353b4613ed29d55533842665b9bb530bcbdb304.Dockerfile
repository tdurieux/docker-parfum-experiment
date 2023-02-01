FROM centos:7

RUN yum -y update
RUN yum -y install git epel-release wget make gcc-c++
RUN yum -y install python34 python34-numpy python34-devel qt5-qtbase-devel qt5-qttools-devel *x11*

# Get SIP working
WORKDIR /tmp
RUN wget http://sourceforge.net/projects/pyqt/files/sip/sip-4.18/sip-4.18.tar.gz
RUN tar xf sip-4.18.tar.gz
WORKDIR /tmp/sip-4.18
RUN python3 configure.py
RUN make -j4
RUN make install

# Compile PyQt5 from source, because it is not available in repos
WORKDIR /tmp
RUN wget http://sourceforge.net/projects/pyqt/files/PyQt5/PyQt-5.5.1/PyQt-gpl-5.5.1.tar.gz
RUN tar xf PyQt-gpl-5.5.1.tar.gz
WORKDIR /tmp/PyQt-gpl-5.5.1
RUN python3 configure.py --qmake /usr/bin/qmake-qt5 --confirm-license
RUN make -j4
RUN make install

ADD run.sh /bin/run.sh
RUN chmod +x /bin/run.sh

RUN dbus-uuidgen > /etc/machine-id

CMD /bin/run.sh