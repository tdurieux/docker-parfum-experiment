FROM fedora:34
MAINTAINER <jdulaney@fedoraproject.org>

#RUN firewall-cmd --permanent --zone=trusted --add-interface=docker0 && \
#    firewall-cmd --reload

#RUN rm -rf /var/cache/dnf/*updates* ; dnf -y update

#RUN useradd mock
RUN dnf -y install cmake gcc-c++ openssl-devel python3-gnuradio gnuradio-devel gr-osmosdr sox gr-osmosdr-devel libusb-devel libcurl-devel fdk-aac-free-devel cppunit-devel libsndfile-devel log4cpp-devel mpir-devel mpir-c++ gmp-devel gmp-c++ fftw-devel uhd-firmware uhd-devel libunwind-devel wget


#ADD https://github.com/robotastic/trunk-recorder/archive/refs/tags/v4.0.tar.gz /home/mock/v4.0.tar.gz
#RUN cd /home/mock ; tar xf v4.0.tar.gz ; rm v4.0.tar.gz ; chown -R mock:mock trunk-recorder-4.0
#RUN su - mock -c 'cd /home/mock/trunk-recorder-4.0/ ; cmake -S "." -B "redhat-linux-build" -DCMAKE_C_FLAGS_RELEASE:STRING="-DNDEBUG" -DCMAKE_CXX_FLAGS_RELEASE:STRING="-DNDEBUG" -DCMAKE_Fortran_FLAGS_RELEASE:STRING="-DNDEBUG" -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_INSTALL_DO_STRIP:BOOL=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr -DINCLUDE_INSTALL_DIR:PATH=/usr/include -DLIB_INSTALL_DIR:PATH=/usr/lib64 -DSYSCONF_INSTALL_DIR:PATH=/etc -DSHARE_INSTALL_PREFIX:PATH=/usr/share -DLIB_SUFFIX=64 -DBUILD_SHARED_LIBS:BOOL=ON ; cd redhat-linux-build ; make '