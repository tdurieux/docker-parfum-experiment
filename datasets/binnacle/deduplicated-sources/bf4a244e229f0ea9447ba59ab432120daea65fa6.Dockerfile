FROM maven:3.5-jdk-8-alpine as build
COPY . /app/
WORKDIR /app
RUN mvn clean install dependency:copy-dependencies


FROM openjdk:8

RUN mkdir /installer && cd /installer && \
    wget --quiet -O install4j_unix_6_1_6.tar.gz \
        http://download-keycdn.ej-technologies.com/install4j/install4j_unix_6_1_6.tar.gz && \
    tar xzf install4j_unix_6_1_6.tar.gz

COPY --from=build \
    /app/license.txt \
    /app/vcell-client/src/main/resources/thirdpartylicenses.txt \
    /app/vcell-client/src/main/resources/vcellSplash.png \
    /vcellclient/
    
COPY --from=build /app/bionetgen      /vcellclient/bionetgen
COPY --from=build /app/exampleModels  /vcellclient/exampleModels
COPY --from=build /app/localsolvers   /vcellclient/localsolvers
COPY --from=build /app/nativelibs     /vcellclient/nativelibs
COPY --from=build /app/pythonScripts  /vcellclient/pythonScripts

COPY --from=build \
    /app/vcell-client/target/vcell-client-0.0.1-SNAPSHOT.jar \
    /app/vcell-client/target/maven-jars/*.jar \
    /vcellclient/vcell-client/target/maven-jars/

COPY --from=build /app/docker/installers /config/
WORKDIR /config

VOLUME /jres
VOLUME /outputdir
VOLUME /buildsecrets

#
# Install4j code signing certificates and Install4J product key (using docker-compose 'secrets' facility)
#
ENV winCodeSignKeystore_pfx=/buildsecrets/winCodeSignKeystore_pfx \
    macCodeSignKeystore_p12=/buildsecrets/macCodeSignKeystore_p12 \
    winCodeSignKeystore_pswdfile=/buildsecrets/winCodeSignKeystore_pswdfile \
    macCodeSignKeystore_pswdfile=/buildsecrets/macCodeSignKeystore_pswdfile \
    Install4J_product_key_file=/buildsecrets/Install4J_product_key_file

#
# these are to be overridden for a particular context
#
ENV compiler_updateSiteBaseUrl="update-site-not-set" \
    compiler_vcellIcnsFile=/install/icons/vcell.icns \
    compiler_mavenRootDir=/vcellclient \
    compiler_softwareVersionString="SOFTWARE-VERSION-NOT-SET" \
    compiler_Site=SITE-NOT-SET \
    compiler_vcellVersion=VCELL-VERSION-NOT-SET \
    compiler_vcellBuild=VCELL-BUILD-NOT-SET \
    compiler_rmiHosts="apihost-not-set:api-port-not-set" \
    compiler_bioformatsJarFile=vcell-bioformats-0.0.5-jar-with-dependencies.jar \
    compiler_bioformatsJarDownloadURL=http://vcell.org/webstart/vcell-bioformats-0.0.5-jar-with-dependencies.jar \
    compiler_applicationId="client-applicationId-not-set" \
    macJre=macosx-amd64-1.8.0_141 \
    win64Jre=windows-amd64-1.8.0_141 \
    win32Jre=windows-x86-1.8.0_141 \
    linux64Jre=linux-amd64-1.8.0_66 \
    linux32Jre=linux-x86-1.8.0_66

ENTRYPOINT [ "/config/build_installers.sh" ]