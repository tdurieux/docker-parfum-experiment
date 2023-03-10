FROM &&OS&&:&&DIST&&
ENV DEBIAN_FRONTEND=noninteractive

ADD php-compiler.sh /root/
ADD versions.sh /root/
ADD ./tests/ /root/tests
RUN chmod +x /root/php-compiler.sh; \
    chmod +x /root/versions.sh; \
    cd /root; \
    /bin/bash /root/php-compiler.sh "&&PHPVL&&"; \
    /etc/init.d/&&PHPVS&&-fpm start; \
    &&PHPVS&& -v; \
    for i in /root/tests/*.php; do echo "$i" && php "$i"; done