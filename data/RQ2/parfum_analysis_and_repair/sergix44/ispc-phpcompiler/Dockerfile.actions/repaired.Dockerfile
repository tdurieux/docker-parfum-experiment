FROM &&OS&&
ENV DEBIAN_FRONTEND=noninteractive

ADD php-compiler.sh /root/
ADD versions.sh /root/
ADD ./tests/ /root/tests
RUN chmod +x /root/php-compiler.sh; \
    chmod +x /root/versions.sh; \
    cd /root; \
    /bin/bash /root/php-compiler.sh "&&PHPVL&&"; \
    exitcode=$?; \
    if [ $exitcode -eq 0 ]; then \
    /etc/init.d/&&PHPVS&&-fpm start; \
    &&PHPVS&& -v; \
    &&PHPVS&& -m; \
    (cd /opt/&&PHPVS&&/bin && ./pear version); \
    for i in /root/tests/*.php; do echo "$i" && php "$i"; done \
    elif [ $exitcode -eq 5 ]; then \
    exit 0; \
    else \
    exit 1; \  
    fi;