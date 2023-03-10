# before docker build can be executed, the war file and the conf
# directory have to be copied into this folder (done by maven build)

# use java as a base image
FROM openjdk:11-jdk

# install python + required packages
RUN apt-get update && apt-get install --no-install-recommends -y python-numpy python-scipy && rm -rf /var/lib/apt/lists/*;

# add webofneeds default config env variables
ENV WON_CONFIG_DIR=/usr/src/matcher-rescal/conf
ENV LOGBACK_CONFIG=logback.xml

# add the jar and the conf directory
ADD ./won-matcher-rescal.jar /usr/src/matcher-rescal/
ADD ./conf ${WON_CONFIG_DIR}

# add the python files
ADD ./python /usr/src/matcher-rescal/python
ENV matcher.rescal.pythonScriptDir=/usr/src/matcher-rescal/python
ENV matcher.rescal.executionDir=/usr/src/matcher-rescal/execution
RUN mkdir -p /usr/src/matcher-rescal/execution/output && rm -rf /usr/src/matcher-rescal/execution/output

# start rescal matcher
WORKDIR /usr/src/matcher-rescal
CMD java -Dconfig.file=${WON_CONFIG_DIR}/matcher-rescal/application.conf -DWON_CONFIG_DIR=${WON_CONFIG_DIR}/matcher-rescal -Dlogback.configurationFile=${WON_CONFIG_DIR}/${LOGBACK_CONFIG} -jar won-matcher-rescal.jar