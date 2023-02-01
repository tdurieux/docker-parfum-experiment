FROM legcowatch/base

RUN pip install --no-cache-dir scrapyd


    [ -r /etc/default/scrapyd ] && . /etc/default/scrapyd
    logdir={{ common.logs_dir }}
    exec scrapyd -u scrapy -g {{ project.group }} \
                --pidfile /var/run/scrapyd.pid \
                -l $logdir/scrapyd.log >$logdir/scrapyd.out 2>$logdir/scrapyd.err