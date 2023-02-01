FROM ubuntu:14.04

MAINTAINER Joao Ricardo "joaoricardo000@gmail.com"

RUN apt-get update && apt-get upgrade -y

# Dependencies
RUN apt-get install --no-install-recommends -y python2.7 python-dev python-pip python-virtualenv && \
	apt-get install --no-install-recommends -y libfontconfig libjpeg-dev zlib1g-dev && \
	apt-get install --no-install-recommends -y git curl supervisor espeak && rm -rf /var/lib/apt/lists/*;

# Node installation to use pageres
RUN curl -f -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
	apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm -g install pageres-cli && npm cache clean --force;

# Copying files
COPY src/ /whatsapp-bot
COPY opt/requirements.pip /requirements.pip
COPY opt/supervisor.conf /etc/supervisor/conf.d
COPY opt/patch.sh /patch.sh

# Create virtualenv with requirements
RUN virtualenv venv && /./venv/bin/pip install -r requirements.pip


# Apply patches
RUN chmod +x /patch.sh
RUN /./patch.sh

EXPOSE 9005

############## EDIT
# Whatsapp Credentials:
ENV WHATSAPP_LOGIN="5544999999999"
ENV WHATSAPP_PW="xxxxxxxxxxxxxxxxxxxxxxxx="
# Bing API KEY for image search
ENV BING_API_KEY=""
# Add a cellphone number to set as admin
ENV WHATSAPP_ADMIN=""
############## /EDIT

CMD ["/usr/bin/supervisord"]