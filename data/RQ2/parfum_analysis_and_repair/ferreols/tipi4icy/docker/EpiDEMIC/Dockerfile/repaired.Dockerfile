FROM ferreol/tipisdk
MAINTAINER Ferreol Soulez ferreol.soulez@univ-lyon1.fr
RUN apk add --no-cache --update openssl && \
    mkdir -p /usr/src && \
    cd /usr/src && \
    wget https://github.com/ferreolS/tipi4icy/archive/jars.zip && \
    unzip jars.zip && \
    mv tipi4icy-jars/EpiDEMIC.jar icy/plugins/. && \
    rm -r tipi4icy-jars jars.zip && \
     apk del openssl && rm -rf /usr/src
WORKDIR /usr/src/icy
ENV DFOLDER=/data
ENTRYPOINT java -jar -Xms$XMS  ./icy.jar -hl  -x plugins.ferreol.demics.EpiDEMIC $DFOLDER/$NAME-param.xml -i $DFOLDER/$NAME.tif*  -r $DFOLDER/$NAME.tif* -o  $DFOLDER/$NAME-dec.tif  -s  $DFOLDER/$NAME-dec-param.xml
