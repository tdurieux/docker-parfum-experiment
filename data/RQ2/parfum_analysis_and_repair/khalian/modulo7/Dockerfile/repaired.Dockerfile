# This is the docker file for the Modulo7 project
FROM    ubuntu:14.04

# Basic message
RUN echo "Building docker image"

# Install installer helper tools
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

# Add global apt repos for dependencies
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu precise universe" && \
    add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu precise main restricted universe multiverse" && \
    add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu precise-updates main restricted universe multiverse" && \
    add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu precise-backports main restricted universe multiverse" && \
    add-apt-repository -y ppa:webupd8team/java

# Update and upgrade the repositories once
RUN apt-get -y update
RUN apt-get -y upgrade

# Install the dependencies of opencv
RUN apt-get -y remove ffmpeg x264 libx264-dev
RUN apt-get -y --no-install-recommends install libopencv-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential checkinstall cmake pkg-config yasm && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libtiff4-dev libjpeg-dev libjasper-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-dev python-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libtbb-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libqt4-dev libgtk2.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install x264 v4l-utils ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libgtk2.0-dev && rm -rf /var/lib/apt/lists/*;

# Install opencv on the image, its needed for the c++ code for omr
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN     git clone https://github.com/Khalian/Install-OpenCV
RUN     chmod +x /Install-OpenCV/Ubuntu/2.4/opencv2_4_9.sh
RUN	    sh /Install-OpenCV/Ubuntu/2.4/opencv2_4_9.sh

# Install java
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
RUN apt-get -y --no-install-recommends -f install oracle-java8-set-default && rm -rf /var/lib/apt/lists/*;

# The installation of tessaract and audiveris prototypes, under construction
RUN apt-get -y --no-install-recommends install tesseract-ocr liblept4 libtesseract3 tesseract-ocr-deu tesseract-ocr-eng tesseract-ocr-fra tesseract-ocr-ita && rm -rf /var/lib/apt/lists/*;
RUN     wget https://kenai.com/projects/audiveris/downloads/download/oldies/audiveris-4.2.3318-ubuntu-amd64.deb -O audiveris.deb
RUN     dpkg -i audiveris.deb

# Install the gradle version 2.5 for building modulo7, canonical's distribution for gradle is outdated so gradle is installed manually
RUN apt-get -y --no-install-recommends install wget unzip && rm -rf /var/lib/apt/lists/*;
RUN     wget https://services.gradle.org/distributions/gradle-2.5-bin.zip
RUN     unzip gradle-2.5-bin.zip

# Build the Modulo7 project
RUN     echo Building the Modulo7 CodeBase
RUN     git clone https://github.com/Khalian/Modulo7
RUN     export PATH=$PATH:/gradle-2.5/bin && cd Modulo7 && gradle build
