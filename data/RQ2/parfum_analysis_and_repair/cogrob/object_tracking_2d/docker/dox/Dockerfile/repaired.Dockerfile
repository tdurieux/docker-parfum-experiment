#From inside this folder
# docker build -t cogrob/ebt-dox .

############################################################
# Dockerfile to build EBT images
# Based on Ubuntu
############################################################

FROM cogrob/ebt-gui
MAINTAINER Cognitive Robotics "http://cogrob.org/"

#Install qtcreator IDE
# RUN apt-get install -y qtcreator

#Install firefox browser for network debuging
RUN apt-get install --no-install-recommends -y firefox && rm -rf /var/lib/apt/lists/*;

#Install Google Chrome, run using 'google-chrome --sand-box'
# RUN wget -q -O - "https://dl-ssl.google.com/linux/linux_signing_key.pub" | sudo apt-key add - \
#  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
#  && apt-get update \
#  && apt-get install -y google-chrome-stable

#Add basic user
ENV USERNAME dox
ENV PULSE_SERVER /run/pulse/native
RUN useradd -m $USERNAME && \
	echo "$USERNAME:$USERNAME" | chpasswd && \
	usermod --shell /bin/bash $USERNAME && \
	usermod -aG sudo $USERNAME && \
	echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
	chmod 0440 /etc/sudoers.d/$USERNAME && \
	# Replace 1000 with your user/group id
	usermod  --uid 1000 $USERNAME && \
	groupmod --gid 1000 $USERNAME

# Fix for qt and X server errors
RUN echo "export QT_X11_NO_MITSHM=1" >> /home/$USERNAME/.bashrc

#Change user
USER dox