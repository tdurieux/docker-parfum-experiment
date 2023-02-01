FROM eclipse-temurin:8-jre-focal

LABEL MAINTAINERS="Julian Uszkoreit <julian.uszkoreit@rub.de>"\
      description="Docker image for command line execution of PIA - Protein Inference Algorithms"

# prepare zip and wget
RUN apt-get update; \
    apt-get install --no-install-recommends -y unzip wget; rm -rf /var/lib/apt/lists/*; \
    apt-get clean

#preparing directories
RUN mkdir -p /data/in; mkdir -p /data/out; mkdir -p /opt/pia;

# download latest PIA zip and uncompress
RUN cd /opt/pia; \
    curl -f -s https://api.github.com/repos/mpc-bioinformatics/pia/releases/latest | grep -oP '"browser_download_url": "\K(.*pia.*.zip)(?=")' | wget -qi - -O pia.zip; \
    unzip pia.zip; \
    rm pia.zip; \
    mv pia*.jar pia.jar;

# cleanup
RUN apt-get remove -y unzip wget;

ENTRYPOINT ["java", "-jar", "/opt/pia/pia.jar"]
CMD ["--help"]
