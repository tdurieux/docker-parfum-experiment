FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y apache2 && apt-get install --no-install-recommends -y libapache2-mod-auth-mellon && rm -rf /var/lib/apt/lists/*;

RUN mkdir /etc/apache2/mellon

COPY mellon/* /etc/apache2/mellon/

COPY auth_mellon.conf /etc/apache2/mods-enabled/

COPY www/* /var/www/html/

RUN mkdir /var/www/html/auth2

COPY www/auth2/* /var/www/html/auth2/

CMD /usr/sbin/apache2ctl -D FOREGROUND
