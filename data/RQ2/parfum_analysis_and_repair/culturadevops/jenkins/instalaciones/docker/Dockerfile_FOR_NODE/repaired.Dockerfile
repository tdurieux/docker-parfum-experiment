FROM jenkins/jenkins:lts
 #https://updates.jenkins.io/download/plugins/
 #docker build -t jenkins .
 #docker run  -p "80:8080" jenkins
USER root

RUN apt-get update -qq \
    && apt-get install --no-install-recommends -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update  -qq \
    && apt-get install --no-install-recommends docker-ce=17.12.1~ce-0~debian -y && rm -rf /var/lib/apt/lists/*;


RUN apt install --no-install-recommends awscli -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade awscli
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;
RUN usermod -aG docker jenkins
