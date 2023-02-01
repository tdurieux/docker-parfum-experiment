# Base image 
FROM debian:testing

# - Install SimGrid's dependencies 
# - Compile and install SimGrid itself. Clean the tree.
# - Remove everything that was installed, and re-install what's needed by the SimGrid libraries before the Gran Final Cleanup
RUN apt update && apt -y upgrade && \
    apt install -y g++ gcc git valgrind default-jdk gfortran libboost-dev libboost-all-dev cmake dpkg-dev && \
    mkdir /source/ && cd /source && git clone --depth=1 https://framagit.org/simgrid/simgrid.git simgrid.git && \
    cd simgrid.git && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/ -Denable_documentation=OFF -Denable_java=ON -Denable_smpi=ON -Denable_compile_optimizations=ON . && \
    make -j4 install && \
    mkdir debian/ && touch debian/control && dpkg-shlibdeps --ignore-missing-info lib/*.so -llib/ -O/tmp/deps && \
    git reset --hard master && git clean -dfx && \
    apt remove -y  g++ gcc git valgrind default-jdk gfortran libboost-dev libboost-all-dev cmake dpkg-dev && \
    apt install `sed -e 's/shlibs:Depends=//' -e 's/([^)]*)//g' -e 's/,//g' /tmp/deps` && \
    apt autoremove -y && apt autoclean && apt clean
