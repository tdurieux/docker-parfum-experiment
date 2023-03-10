FROM nvidia/cuda:9.1-devel-ubuntu16.04


ENV mysql_database "ipt_bugs"
ENV mysql_password "samplepassword"


COPY Bug_Collection                   /IPT/UI/Bug_Collection
#COPY BugDatabase      /IPT/UI/BugDatabase
#COPY BugDatabase_lib      /IPT/UI/BugDatabase_lib
# UI code
#  COPY BugDatabase.jar                 /IPT/UI/BugDatabase.jar
COPY setup.sh                                         /IPT/UI/setup.sh
COPY mysql-connector-java-8.0.16.jar                  /IPT/UI/mysql-connector-java-8.0.16.jar
COPY BugDatabase/src/BaseView_v4.java                 /IPT/UI/BaseView_v4.java
COPY BugDatabase/src/HighlightTreeCellRenderer.java   /IPT/UI/HighlightTreeCellRenderer.java
COPY json-20180813.jar                                /IPT/UI/json-20180813.jar


WORKDIR /IPT/UI


RUN export DEBIAN_FRONTEND=noninteractive &&\
    apt-get update && apt install --no-install-recommends mysql-server default-jre default-jdk ecj python3 python3-pip libcr-dev mpich -y && \
    pip3 install --no-cache-dir mysql-connector && apt-get install --no-install-recommends xterm -y && \
    chmod +x /IPT/UI/setup.sh && rm -rf /var/lib/apt/lists/*;


CMD ./setup.sh
