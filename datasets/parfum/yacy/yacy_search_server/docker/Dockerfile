# Build a docker image from latest YaCy sources

# Base image : latest Debian stable official jdk 8 image from Docker
FROM openjdk:8-stretch

# Install needed packages not in base image 
# (curl for sh scripts in /bin, and wkhtmltopdf,imagemagick,xvfb and ghostscript to enable PDF and image snapshot generation)
RUN apt-get update && apt-get install -yq curl wkhtmltopdf imagemagick xvfb ghostscript && \
  rm -rf /var/lib/apt/lists/*

# trace java version
RUN java -version

# set current working dir
WORKDIR /opt

# All in one step to reduce image size growth :
# - install ant package
# - Compile with ant
# - remove unnecessary and size consuming .git directory
# - remove ant package

# copy sources
COPY . /opt/yacy_search_server/

RUN rm -rf /opt/yacy_search_server/.git && \
    apt-get update && \
	apt-get install -yq ant && \
	ant compile -f /opt/yacy_search_server/build.xml && \
	apt-get purge -yq --auto-remove ant && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN \
# Set initial admin password: "yacy" (encoded with custom yacy md5 function net.yacy.cora.order.Digest.encodeMD5Hex())
# > java -classpath classes net.yacy.cora.order.Digest -strfhex "admin:The YaCy access is limited to administrators. If you don't know the password, you can change it using <yacy-home>/bin/passwd.sh <new-password>:docker"
	sed -i "/adminAccountBase64MD5=/c\adminAccountBase64MD5=MD5:8cffbc0d66567a0987a4aba1ec46d63c" /opt/yacy_search_server/defaults/yacy.init && \
	sed -i "/adminAccountForLocalhost=/c\adminAccountForLocalhost=false" /opt/yacy_search_server/defaults/yacy.init && \
# Intially enable HTTPS: this is the most secure option for remote administrator authentication
	sed -i "/server.https=false/c\server.https=true" /opt/yacy_search_server/defaults/yacy.init && \
# Create user and group yacy: this user will be used to run YaCy main process
	adduser --system --group --no-create-home --disabled-password yacy && \
# Set ownership of yacy install directory to yacy user/group
	chown yacy:yacy -R /opt/yacy_search_server

# Expose HTTP and HTTPS default ports
EXPOSE 8090 8443

# Set data volume: yacy data and configuration will persist even after container stop or destruction
VOLUME ["/opt/yacy_search_server/DATA"]

# Next commands run as yacy as non-root user for improved security
USER yacy

# Start yacy as a foreground process (-f) to display console logs and to wait for yacy process
CMD ["/bin/sh","/opt/yacy_search_server/startYACY.sh","-f"]
