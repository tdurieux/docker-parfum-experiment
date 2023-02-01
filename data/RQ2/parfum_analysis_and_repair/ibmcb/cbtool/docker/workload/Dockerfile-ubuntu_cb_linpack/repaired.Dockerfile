FROM REPLACE_NULLWORKLOAD_UBUNTU

# linpack-install-man
RUN mkdir -p /home/REPLACE_USERNAME/linpack/benchmarks/linpack; sudo chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME/linpack/
RUN wget -N -v -P /home/REPLACE_USERNAME/linpack https://registrationcenter.intel.com/irc_nas/7615/l_lpk_p_11.3.0.004.tgz
#RUN REPLACE_RSYNC/l_lpk_p_11.3.0.004.tgz /home/REPLACE_USERNAME/linpack/
RUN cd /home/REPLACE_USERNAME/linpack/; sudo tar -xzvf l_lpk_p_11.3.0.004.tgz && rm l_lpk_p_11.3.0.004.tgz
# linpack-install-man

# Newer linpack
RUN mkdir -p /home/REPLACE_USERNAME/linpack_2.3; sudo chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME/linpack_2.3
RUN wget -N -v -P /home/REPLACE_USERNAME/linpack_2.3 https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.5.tar.gz
RUN cd /home/REPLACE_USERNAME/linpack_2.3/; sudo tar -xzvf openmpi-4.0.5.tar.gz; rm openmpi-4.0.5.tar.gz cd openmpi-4.0.5; CFLAGS="-Ofast -march=native" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/openmpi; make -j4; make -j4 install; ln -s /opt/openmpi/lib/libmpi.so.40 /opt/openmpi/lib/libmpi.so.20

RUN wget -N -v -P /home/REPLACE_USERNAME/linpack_2.3 https://github.com/amd/blis/archive/2.2.tar.gz; cd /home/REPLACE_USERNAME/linpack_2.3/; sudo tar -xzvf 2.2.tar.gz && rm 2.2.tar.gz

RUN cd /home/REPLACE_USERNAME/linpack_2.3/blis-2.2; CFLAGS="-Ofast -march=native" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared --enable-cblas --enable-threading=openmp --prefix=/opt/blis_amd zen; make -j4; make install

RUN cd /home/REPLACE_USERNAME/linpack_2.3/blis-2.2; CFLAGS="-Ofast -march=native" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared --enable-cblas --enable-threading=openmp --prefix=/opt/blis_intel intel64; make -j4; make install

RUN wget -N -v -P /home/REPLACE_USERNAME/linpack_2.3 https://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz; cd /home/REPLACE_USERNAME/linpack_2.3/; sudo tar -xzvf hpl-2.3.tar.gz && rm hpl-2.3.tar.gz

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
