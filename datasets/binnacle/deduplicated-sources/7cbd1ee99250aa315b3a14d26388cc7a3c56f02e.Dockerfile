FROM openjdk:8

RUN mkdir /installer && cd /installer && \
    wget --quiet -O install4j_unix_7_0_8.tar.gz \
        http://download-keycdn.ej-technologies.com/install4j/install4j_unix_7_0_8.tar.gz && \
    tar xzf install4j_unix_7_0_8.tar.gz

COPY ./license.txt \
    ./vcell-client/src/main/resources/thirdpartylicenses.txt \
    ./vcell-client/src/main/resources/vcellSplash.png \
    /vcellclient/

COPY ./bionetgen      /vcellclient/bionetgen
COPY ./exampleModels  /vcellclient/exampleModels
COPY ./localsolvers   /vcellclient/localsolvers
COPY ./nativelibs     /vcellclient/nativelibs
COPY ./pythonScripts  /vcellclient/pythonScripts

COPY ./vcell-client/target/vcell-client-0.0.1-SNAPSHOT.jar \
    ./vcell-client/target/maven-jars/*.jar \
    /vcellclient/vcell-client/target/maven-jars/

COPY ./docker/build/installers /config/
WORKDIR /config

VOLUME /jres
VOLUME /outputdir
VOLUME /buildsecrets

#
# Install4j code signing certificates and Install4J product key (using docker-compose 'secrets' facility)
#
ENV winCodeSignKeystore_pfx=Expecting_this_to_be_defined_runtime_for_winCodeSignKeystore_pfx \
    macCodeSignKeystore_p12=Expecting_this_to_be_defined_runtime_for_macCodeSignKeystore_p12 \
    winCodeSignKeystore_pswdfile=Expecting_this_to_be_defined_runtime_for_winCodeSignKeystore_pswdfile \
    macCodeSignKeystore_pswdfile=Expecting_this_to_be_defined_runtime_for_macCodeSignKeystore_pswdfile \
    Install4J_product_key_file=Expecting_this_to_be_defined_runtime_for_Install4J_product_key_file

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
    compiler_bioformatsJarFile=vcell-bioformats-0.0.8-jar-with-dependencies.jar \
    compiler_bioformatsJarDownloadURL=http://vcell.org/webstart/vcell-bioformats-0.0.8-jar-with-dependencies.jar \
    compiler_applicationId="client-applicationId-not-set" \
    macJre=macosx-amd64-1.8.0_141 \
    win64Jre=windows-amd64-1.8.0_141 \
    win32Jre=windows-x86-1.8.0_141 \
    linux64Jre=linux-amd64-1.8.0_66 \
    linux32Jre=linux-x86-1.8.0_66

ENTRYPOINT [ "/config/build_installers.sh" ]