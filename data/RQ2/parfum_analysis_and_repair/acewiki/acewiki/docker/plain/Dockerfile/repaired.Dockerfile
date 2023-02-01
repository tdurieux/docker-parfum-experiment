FROM ubuntu:latest
WORKDIR /opt/application
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y wget git ant && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y swi-prolog swi-prolog-java && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openjdk-7-jdk && rm -rf /var/lib/apt/lists/*;
RUN git clone --depth=1 https://github.com/Attempto/APE.git
WORKDIR /opt/application/APE
RUN bash make_exe.sh
WORKDIR /opt/application
RUN git clone --depth=1 https://github.com/AceWiki/AceWiki
WORKDIR /opt/application/AceWiki
RUN ant createwebapps
RUN mv ../APE/ape.exe .
RUN wget -O jetty-runner.jar https://repo2.maven.org/maven2/org/mortbay/jetty/jetty-runner/8.1.9.v20130131/jetty-runner-8.1.9.v20130131.jar
ENV LD_PRELOAD /usr/lib/swi-prolog/lib/amd64/libjpl.so
ENV LD_LIBRARY_PATH /usr/lib/jvm/default-java/jre/lib/amd64:/usr/lib/jvm/default-java/jre/lib/amd64/server
EXPOSE 9077
CMD java -Xmx400m -Xss4m -Djava.library.path=/usr/lib/swi-prolog/lib/amd64/ -Djava.awt.headless=true -jar jetty-runner.jar --port 9077 --jar /usr/lib/swi-prolog/lib/jpl.jar acewiki.war
