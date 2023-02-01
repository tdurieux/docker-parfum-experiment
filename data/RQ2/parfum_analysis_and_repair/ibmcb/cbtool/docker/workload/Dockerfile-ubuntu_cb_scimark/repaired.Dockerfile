FROM REPLACE_NULLWORKLOAD_UBUNTU

# java-install-pm
RUN apt-get update; apt install --no-install-recommends -y openjdk-8-jre:REPLACE_ARCH3 openjdk-8-jre-headless:REPLACE_ARCH3 openjdk-8-jdk:REPLACE_ARCH3 && rm -rf /var/lib/apt/lists/*;
RUN sudo apt --fix-broken -y install
# java-install-pm

# scimark-install-man
RUN wget -N -v -P /home/REPLACE_USERNAME https://math.nist.gov/scimark2/scimark2lib.zip
RUN apt-get install --no-install-recommends -y unzip; rm -rf /var/lib/apt/lists/*; cd /home/REPLACE_USERNAME; unzip -qu /home/REPLACE_USERNAME/scimark2lib.zip
# scimark-install-man

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
