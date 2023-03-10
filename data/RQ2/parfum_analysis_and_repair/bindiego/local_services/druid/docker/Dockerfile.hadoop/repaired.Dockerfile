FROM sequenceiq/hadoop-docker:2.7.1
MAINTAINER Bin Wu <bin.wu@ptengine.com>

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090
# Mapred ports
EXPOSE 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 2122
# More missing hdfs ports
EXPOSE 8020 9000