FROM selenoid/dev_opera:@@VERSION@@

COPY selenium-server-standalone.jar /usr/share/selenium/
COPY entrypoint.sh /

USER selenium

EXPOSE 4444
ENTRYPOINT ["/entrypoint.sh"]
