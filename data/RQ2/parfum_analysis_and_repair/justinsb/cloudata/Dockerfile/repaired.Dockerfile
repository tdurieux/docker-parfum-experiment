FROM justinsb/java8

RUN apt-get install --no-install-recommends --yes curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://install.meteor.com | sh

ADD . /src/
#RUN cd /src; mvn install

RUN cd /src/cloudata-git/src/main/webapp; meteor build --directory ../../../target/meteor

RUN cd /src; mvn install assembly:single

CMD cd /src/cloudata-git/target/cloudata-git-1.0-SNAPSHOT-bundle; /opt/java/bin/java -cp "lib/*" com.cloudata.git.GitServer
