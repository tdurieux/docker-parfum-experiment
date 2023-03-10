FROM ubuntu:20.10
# without this we get "source not found"
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt update && apt install --no-install-recommends -y curl git zip unzip && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://get.sdkman.io | bash

RUN chmod a+x "$HOME/.sdkman/bin/sdkman-init.sh"
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install java 8.0.265-open
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install grails 3.3.10
#RUN /bin/bash -c "source $HOME/.sdkman/bin/sdkman-init.sh"

# sdk command doesnt exists
# RUN sdk version
# RUN sdk install grails 3.3.10

RUN grails -version

COPY . /ehrserver
WORKDIR /ehrserver
# MySQL is running on the host machine, EHRServer expects:
# database: ehrserver2
# host: localhost:3306
# username: taken from local env var EHRSERVER_MYSQL_DB_USERNAME
# password: taken from local env var EHRSERVER_MYSQL_DB_PASSWORD
CMD ["grails", "run-app"]
