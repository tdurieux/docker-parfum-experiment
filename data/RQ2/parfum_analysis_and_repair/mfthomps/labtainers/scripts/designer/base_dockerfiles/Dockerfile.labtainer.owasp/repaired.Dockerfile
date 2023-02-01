FROM mfthomps/labtainer.firefox
LABEL description="This is base Docker image for Labtainer containers with OWASP web vulnerability tool set"
RUN cp /var/tmp/sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/cabelo/xUbuntu_17.10/ /' > /etc/apt/sources.list.d/home:cabelo.list"
RUN sudo wget -nv https://download.opensuse.org/repositories/home:cabelo/xUbuntu_18.04/Release.key -O Release.key
RUN sudo apt-key add - < Release.key
RUN apt-get update
RUN apt-get install --no-install-recommends -y owasp-zap && rm -rf /var/lib/apt/lists/*;
#to run owasp zap at the terminal run owasp-zap
#*******OWASP INSTALL******
#
#****Nano&Curl install****
RUN sudo apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

