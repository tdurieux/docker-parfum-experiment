FROM openjdk:8-jdk
# without this we get "source not found"
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt update && apt install -y --no-install-recommends git zip unzip && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://get.sdkman.io | bash

#RUN chmod a+x "$HOME/.sdkman/bin/sdkman-init.sh"
#RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install java 8.0.265-open
#RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install grails 3.3.10

ENV GRAILS_VERSION 3.3.10
#RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install grails 3.3.10"
RUN source $HOME/.sdkman/bin/sdkman-init.sh && sdk install grails $GRAILS_VERSION

# sdk command doesnt exists
# RUN sdk version
# RUN sdk install grails 3.3.10
RUN echo $HOME

# with $HOME instead of /root it doesnt work...
ENV GRAILS_HOME "/root/.sdkman/candidates/grails/$GRAILS_VERSION"
#RUN echo $GRAILS_HOME
ENV PATH $GRAILS_HOME/bin:$PATH
RUN echo $PATH
RUN ls $HOME/.sdkman/candidates/grails
RUN $GRAILS_HOME/bin/grails -version

COPY . /ehrserver
WORKDIR /ehrserver
EXPOSE 8090
# MySQL is running on the host machine, EHRServer expects:
# database: ehrserver2
# host: localhost:3306
# username: taken from local env var EHRSERVER_MYSQL_DB_USERNAME
# password: taken from local env var EHRSERVER_MYSQL_DB_PASSWORD
#CMD ["grails", "run-app"]
RUN grails clean
ENTRYPOINT ["grails"]
CMD ["run-app"]
