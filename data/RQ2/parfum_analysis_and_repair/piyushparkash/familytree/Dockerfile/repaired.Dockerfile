FROM linode/lamp
LABEL maintainer "achyutapiyush@gmail.com"

RUN apt-get update && apt-get install --no-install-recommends -f -y phpmyadmin lamp-server^ && rm -rf /var/lib/apt/lists/*;
RUN /var/www/FamilyTree

ADD ./* /var/www/FamilyTree/


EXPOSE 80
