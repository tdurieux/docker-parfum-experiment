FROM monetas/base-ot-dev

MAINTAINER Darragh Grealish "darragh@monetas.net"

WORKDIR /home/otuser
RUN mkdir -p opentxs-source/build
ADD CMakeLists.txt .clang-format .gitignore .gitmodules /home/otuser/opentxs-source/
ADD cmake /home/otuser/opentxs-source/cmake
ADD deps /home/otuser/opentxs-source/deps
ADD scripts /home/otuser/opentxs-source/scripts
ADD tests /home/otuser/opentxs-source/tests
ADD wrappers /home/otuser/opentxs-source/wrappers
ADD include /home/otuser/opentxs-source/include
ADD .git /home/otuser/opentxs-source/.git
ADD src /home/otuser/opentxs-source/src
WORKDIR /home/otuser/opentxs-source/build
RUN cmake .. \
        -DPYTHON=1 \
        -DSIGNAL_HANLDER=ON \
        -DPYTHON_EXECUTABLE=/usr/bin/python3 \
        -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.4m.so \
        -DPYTHON_INCLUDE_DIR=/usr/include/python3.4 \
    && make -j 4 -l 2 && make install && ldconfig
