FROM REPLACE_NULLWORKLOAD_UBUNTU

# cuda-ARCHx86_64-install-man
RUN echo "deb http://ppa.launchpad.net/graphics-drivers/ppa/ubuntu bionic main " > /tmp/nvidia.list; echo "deb-src http://ppa.launchpad.net/graphics-drivers/ppa/ubuntu bionic main" >> /tmp/nvidia.list
RUN mv /tmp/nvidia.list /etc/apt/sources.list.d/nvidia.list; apt-get update
RUN apt install --no-install-recommends -y --allow-unauthenticated nvidia-driver-410 nvidia-utils-410 nvidia-cuda-toolkit && rm -rf /var/lib/apt/lists/*;
# cuda-ARCHx86_64-install-man

## cuda-ARCHppc64le-install-man
RUN REPLACE_RSYNC/cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_REPLACE_ARCH3.deb /home/REPLACE_USERNAME/
RUN dpkg -i /home/REPLACE_USERNAME/cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_REPLACE_ARCH3.deb
RUN apt-key add /var/cuda-repo-*/7fa2af80.pub
RUN REPLACE_RSYNC/cudnn-10.0-linux-REPLACE_ARCH4-v7.4.2.24.tar /home/REPLACE_USERNAME/
RUN apt-get install -fy
## cuda-ARCHppc64le-install-man

# parboil-install-man
RUN REPLACE_RSYNC/pb2.5driver.tar /home/REPLACE_USERNAME/
RUN REPLACE_RSYNC/pb2.5datasets_standard-2.tgz /home/REPLACE_USERNAME/
RUN REPLACE_RSYNC/pb2.5benchmarks-2.tgz /home/REPLACE_USERNAME/
RUN cd /home/REPLACE_USERNAME; tar -xf pb2.5driver.tar && rm pb2.5driver.tar
RUN cd /home/REPLACE_USERNAME; tar -xf pb2.5benchmarks-2.tgz; rm pb2.5benchmarks-2.tgz mv benchmarks /home/REPLACE_USERNAME/parboil
RUN cd /home/REPLACE_USERNAME; tar -xf pb2.5datasets_standard-2.tgz; rm pb2.5datasets_standard-2.tgz mv datasets /home/REPLACE_USERNAME/parboil
RUN cd /home/REPLACE_USERNAME/parboil; chmod u+x ./parboil; chmod u+x benchmarks/*/tools/compare-output
# parboil-install-man

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
