FROM base:latest

# todo: collapse these to single command
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:webupd8team/java
RUN apt-get update
RUN echo "yes" | apt-get install --no-install-recommends -y oracle-java7-installer && rm -rf /var/lib/apt/lists/*;

RUN adduser minecraft && mkdir /minecraft && chown minecraft:minecraft /minecraft
WORKDIR /minecraft
ADD minecraft_server*.jar start.sh advertise.py eula.txt server.properties /minecraft/


# This fails,
# RUN java -Xms1G -Xmx1G -jar minecraft_server.1.10.2.jar nogui
# TODO: create server.properties, and an eula.txt
CMD ["./start.sh"]