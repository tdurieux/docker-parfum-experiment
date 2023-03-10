FROM openjdk:8u292-slim AS imageWithDependencies

RUN apt-get update -y && apt-get install --no-install-recommends wget unzip -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /tools
RUN wget https://github.com/grails/grails-core/releases/download/v2.4.4/grails-2.4.4.zip -O /tools/grails.zip
RUN ls -lh /tools
RUN unzip /tools/grails.zip -d /tools

# We first copy the BuildConfig.groovy file
# This way, we retrieve all grails/maven dependencies at the beginning. All these steps will be cached by Docker unless BuildConfig.groovy has been updated.
# This means that we only retrieve all dependencies if we modify the dependencies definition.

COPY ./grails-app/conf/BuildConfig.groovy /app/grails-app/conf/BuildConfig.groovy

RUN cd /app && \
    /tools/grails-2.4.4/bin/grails compile --stacktrace

FROM imageWithDependencies

COPY . /app

ARG VERSION_NUMBER

ENV VERSION_NUMBER_ENV=$VERSION_NUMBER

RUN sed -i -- 's/app.version=0.0.0/app.version='$VERSION_NUMBER'/g' /app/application.properties
ENV GRAILS_OPTS="-Xmx2G -Xms512m -XX:MaxPermSize=512m"

WORKDIR /app
CMD /tools/grails-2.4.4/bin/grails war