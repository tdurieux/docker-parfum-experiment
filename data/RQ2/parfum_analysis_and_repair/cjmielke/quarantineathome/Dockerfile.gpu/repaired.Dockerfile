#FROM ubuntu:18.04
FROM nvidia/opencl

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget build-essential && rm -rf /var/lib/apt/lists/*;
# build fails unless these are separate apt-get installs - don't consolidate
RUN apt-get install --no-install-recommends -y git csh python2.7 python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir requests

#RUN mkdir /client

##### Install MGLtools, which provides some utility scripts we need for both CPU and GPU versions
##### Need mglTools for both CPU and GPU versions - could make this a base image

RUN wget https://mgltools.scripps.edu/downloads/downloads/tars/releases/REL1.5.6/mgltools_x86_64Linux2_1.5.6.tar.gz
RUN tar -xvzf mgltools_x86_64Linux2_1.5.6.tar.gz && rm mgltools_x86_64Linux2_1.5.6.tar.gz
#RUN cd /mgltools_x86_64Linux2_1.5.6 ; tar -xvzf MGLToolsPckgs.tar.gz
RUN cd /mgltools_x86_64Linux2_1.5.6 ; ./install.sh
#RUN mv mgltools_x86_64Linux2_1.5.6 /mgtools





RUN wget https://autodock.scripps.edu/downloads/autodock-registration/tars/dist426/autodocksuite-4.2.6-src.tar.gz
RUN mkdir /autodock
RUN cd /autodock ; tar -xvzf /autodocksuite-4.2.6-src.tar.gz && rm /autodocksuite-4.2.6-src.tar.gz
RUN ls /autodock

RUN cd /autodock/src/autogrid/ ; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make ; make install
RUN cd /autodock/src/autodock/ ; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make ; make install



#RUN apt-get install -y git opencl-c-headers ocl-icd-libopencl1 ocl-icd-opencl-dev
#RUN apt-get install -y nvidia-opencl-dev nvidia-opencl-icd-384

RUN git clone https://github.com/ccsb-scripps/AutoDock-GPU ; cd AutoDock-GPU ; make DEVICE=GPU NUMWI=32
RUN cd /AutoDock-GPU ; ls
RUN ls
RUN pwd
RUN cd /model/ ; ls



COPY requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt



COPY *.py /
COPY docking /docking/
COPY *.sh /
COPY receptors /receptors
COPY .git /.git




#RUN apt-get install -y git opencl-c-headers ocl-icd-libopencl1 ocl-icd-opencl-dev
#COPY sars2-docking /model
#CMD cd /model/ ; /AutoDock-GPU/bin/autodock_gpu_32wi -ffile chainE.maps.fld -lfile DCABRM.xaa_ligand_200.pdbqt -nrun 100


ENTRYPOINT ["/quarantine.sh"]

