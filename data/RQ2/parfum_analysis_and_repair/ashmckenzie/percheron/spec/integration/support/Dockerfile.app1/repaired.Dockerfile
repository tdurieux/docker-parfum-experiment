FROM percheron-test_base:9.9.9
MAINTAINER ash@the-rebellion.net

ENV HOME /root
ENV TERM ansi

EXPOSE 12349

CMD [ "sh", "-c", "while true; do date ; echo 'hello from percheron'; done" ]