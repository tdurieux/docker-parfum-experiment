FROM ubuntu:18.04
ADD ./Game_Engine_Linux_Bin /
RUN /assemble.sh

FROM ubuntu:18.04
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y python python-pip && rm -rf /var/lib/apt/lists/*;
#RUN apt-get install -y net-tools vim
RUN apt-get install --no-install-recommends -y libc++-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir mcstatus ec2-metadata boto3
COPY --from=0 /BinLinux64.Dedicated/* /BinLinux64.Dedicated/
COPY --from=0 /BinLinux64.Dedicated/qtlibs /BinLinux64.Dedicated/qtlibs/
ADD ./eks-artifacts/start.sh /start.sh
ADD ./eks-artifacts/start.py /start.py
ADD MultiplayerSample_pc_Paks_Dedicated /BinLinux64.Dedicated/
