{{#amd64}}
FROM jess/chrome
{{/amd64}}

USER root

RUN usermod -u 1000 chrome && groupmod -g 1000 chrome
RUN chown chrome:chrome /home/chrome

USER chrome