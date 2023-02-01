FROM buildpack-deps:stable-curl

ARG JAVA_VERSION

WORKDIR /usr/massim

ENV JABBA_COMMAND "install ${JAVA_VERSION} -o /jdk"
RUN curl -f -L https://github.com/shyiko/jabba/raw/master/install.sh | bash
ENV JAVA_HOME /jdk
ENV PATH $JAVA_HOME/bin:$PATH

RUN apt-get update && apt-get -y --no-install-recommends install git maven && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/agentcontest/massim_2020.git .
RUN mvn clean package