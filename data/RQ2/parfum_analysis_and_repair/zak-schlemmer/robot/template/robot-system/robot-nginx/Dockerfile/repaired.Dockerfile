# use the latest nginx image
FROM nginx:1.11

# apt-get what we need
#RUN apt update && apt install -y \
#  telnet \
#  vim \
#  nano \
#  net-tools \
#  wget

# conf cp
COPY ./projects/robot-system/robot-nginx/template.nginx.conf /etc/nginx/nginx.conf

# root .bashrc