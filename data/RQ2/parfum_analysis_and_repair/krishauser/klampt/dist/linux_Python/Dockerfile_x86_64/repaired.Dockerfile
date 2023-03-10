FROM quay.io/pypa/manylinux2010_x86_64

RUN yum install -y git gcc glpk glpk-devel mesa-libGLU-devel cmake3 && rm -rf /var/cache/yum

RUN git clone https://github.com/assimp/assimp.git
RUN cd assimp; cmake3 .; make -j 8; make install

RUN git clone https://github.com/krishauser/Klampt
RUN cd /Klampt; git checkout master

RUN cd /Klampt/Cpp/Dependencies; make unpack-deps
#take out the sudo call
RUN cd /Klampt/Cpp/Dependencies; cd glew-2.0.0; make -j 8; make install
RUN cd /Klampt/Cpp/Dependencies; make dep-tinyxml
RUN cd /Klampt/Cpp/Dependencies; make dep-ode
RUN cd /Klampt/Cpp/Dependencies/KrisLibrary; cmake3 . -DC11_ENABLED=ON; make -j 8

RUN cd /Klampt; cmake3 .; make -j 8 Klampt


