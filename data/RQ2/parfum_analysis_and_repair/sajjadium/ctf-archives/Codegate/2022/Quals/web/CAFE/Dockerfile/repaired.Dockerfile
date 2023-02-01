FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install apache2 software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install --no-install-recommends -y libapache2-mod-php8.1 php8.1 php8.1-cli php8.1-mysql php8.1-mbstring && rm -rf /var/lib/apt/lists/*;
RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/apache2.conf && \
    sed -i 's#AllowOverride [Nn]one#AllowOverride All#' /etc/apache2/apache2.conf
RUN a2enmod rewrite
RUN apt install --no-install-recommends -y python3 python3-pip wget && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install selenium webdriver_manager 
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install --no-install-recommends -y ./google-chrome-stable_current_amd64.deb && rm -rf /var/lib/apt/lists/*;
ADD bot.sh /run.sh
ADD bot.py /bot.py
RUN chmod +x /run.sh
RUN chmod +x /bot.py

#execute selenium well.
RUN chmod 777 /var/www


EXPOSE 80

CMD apachectl -D FOREGROUND