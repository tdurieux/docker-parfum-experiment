# More info at:
# https://github.com/tedsluis/docker-dump1090
# https://github.com/mutability/dump1090
# https://hub.docker.com/r/tedsluis/dump1090-mutability
# http://discussions.flightaware.com/post180185.html
# https://www.youtube.com/watch?v=h4YyFDTS6CQ

# This dockerfile can be used to build the original dump1090-mutability (v1.15) 
# running on X86_64/AMD64 (Intel or AMD cpu's).

# Build it yourself:  
#                      $ docker build -t tedsluis/dump1090-mutability:v1.15 .

# Run it:    
#                      $ docker run -d -h dump01 -p 8080:80 tedsluis/dump1090-mutability:v1.15
                      
# Or run it with a different BEAST source:    
#                      $ docker run -d -h dump01 -p 8080:80 tedsluis/dump1090-mutability:v1.15 /usr/share/dump1090-mutability/startdump1090.sh <IP address of your own remote dump1090 source>

FROM debian:latest

MAINTAINER Ted Sluis, Utrecht, The Netherlands, ted.sluis@gmail.com

# Required settings
RUN sed -i 's/exit 101/exit 0/g' /usr/sbin/policy-rc.d
ENV DEBIAN_FRONTEND noninteractive

# Install required packages:
RUN apt-get update && apt-get install -y \
	apt-utils \
	cron      \
	curl	  \
	dialog    \
 	git       \
        lighttpd  \
	netcat	  \
	net-tools \
	python2.7 \
	wget

# Update to the latest software packages:
RUN apt-get update && apt-get upgrade -y

# Install required packages for building dump1090:
RUN apt-get update && apt-get install -y \
	debhelper        \
	dpkg-dev         \ 
	librtlsdr-dev    \
	librtlsdr0       \
	libusb-1.0-0-dev \
	pkg-config       \
	rtl-sdr 

# Prepare for install
RUN ln /usr/bin/python2.7 /usr/bin/python2
RUN mkdir /tmp/dump1090

# Clone, build and install dump1090 from source.
RUN cd /tmp/dump1090 && git clone https://github.com/mutability/dump1090.git /tmp/dump1090 
RUN cd /tmp/dump1090 && dpkg-buildpackage -b
RUN cd /tmp          && dpkg -i dump1090-mutability_1.15~dev_amd64.deb

# Download config files.
# note: If you use other config files, be sure you configure them before building the image. Don't use the default config files, because you won't be able to configure them!
RUN wget -O /usr/share/dump1090-mutability/html/config.js       https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/config.js.org
RUN wget -O /etc/default/dump1090-mutability                    https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/dump1090-mutability

# Add terrain-limit rings. To enable this:
# # create a panorama for your receiver location on heywhatsthat.com
# # note the "view" value from the URL at the top of the panorama
# # i.e. the XXXX in http://www.heywhatsthat.com/?view=XXXX
# # fetch a json file from the API for the altitudes you want to see:
# # wget -O /usr/share/dump1090-mutability/html/upintheair.json \
# # 'http://www.heywhatsthat.com/api/upintheair.json?id=XXXX&refraction=0.25&alts=3048,9144'
# # NB: altitudes are in _meters_, you can specify a list of altitudes
RUN wget -O /usr/share/dump1090-mutability/html/upintheair.json 'http://www.heywhatsthat.com/api/upintheair.json?id=M7R4MI9M&refraction=0.25&alts=100,1000,10000'

# Open the firewall for http and incoming BEAST-format
EXPOSE 80
EXPOSE 30104

# Configure the webserver:
RUN lighty-enable-mod dump1090

# Create startdump1090.sh script
# note: Change the default IP address of the remote dump1090 source in the startdump1090.sh script or specify the script with the IP address while you start the container!
RUN wget -O /usr/share/dump1090-mutability/startdump1090.sh https://raw.githubusercontent.com/tedsluis/docker-dump1090/master/startdump1090.sh
RUN chmod 775 /usr/share/dump1090-mutability/startdump1090.sh

# This is the place where you can put your own ADS-B BEAST source.
# Replace the IP address with a dump1090 instance.
RUN sed -i 's/^([\s]+)ip="\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"/${1}ip="130.211.186.77"/g' /usr/share/dump1090-mutability/startdump1090.sh

# Add labels
LABEL architecture="AMD64,X86_64"
LABEL dump1090version="v1.15"

# Start lighttp web server, BEAST-format input (netcat) and Dump1090
CMD ["/bin/bash", "/usr/share/dump1090-mutability/startdump1090.sh"]
