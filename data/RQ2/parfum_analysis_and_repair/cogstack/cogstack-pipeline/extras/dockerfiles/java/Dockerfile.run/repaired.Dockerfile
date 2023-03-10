FROM openjdk:11-jre-slim

# tesseract-ocr < 4.0 is only available from the previous Debian Stretch distribution
RUN echo "deb http://ftp.de.debian.org/debian stretch main" >> /etc/apt/sources.list

RUN apt-get update && \
#	apt-get dist-upgrade -y && \
#	apt-get install -y tesseract-ocr && \
	apt-get install --no-install-recommends -y tesseract-ocr-osd=3.04.00-1 tesseract-ocr-eng=3.04.00-1 tesseract-ocr=3.04.01-5 && \
	apt-get install --no-install-recommends -y imagemagick --fix-missing && \
	apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
