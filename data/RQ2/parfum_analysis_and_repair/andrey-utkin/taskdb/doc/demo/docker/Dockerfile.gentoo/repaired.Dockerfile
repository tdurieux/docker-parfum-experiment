# name the portage image
FROM gentoo/portage:20200310 as portage

# image is based on stage3-amd64
FROM gentoo/stage3-amd64-nomultilib:20200310

# copy the entire portage volume in
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

CMD /sbin/init

# configs, extra service startup scripts etc
COPY ./gentoo/ /

RUN emerge layman
RUN layman -S
RUN layman -a andrey_utkin

# --onlydeps is just a convenience measure
# to take advantage of Docker's stage cache.
# Plenty of heavyweight dependencies don't change much.
# taskdb itself changes a lot, so install it on the last step.
RUN emerge --onlydeps app-misc/taskdb
RUN rc-update add postgresql-12 default

# optional runtime deps
RUN emerge www-apps/grafana-bin
RUN rc-update add grafana default

RUN emerge www-servers/nginx
RUN rc-update add nginx default
RUN mkdir -p /var/www/taskdb/htdocs
RUN sed -i -e 's/listen 127.0.0.1;/listen 0.0.0.0;/' -e 's|root /var/www/localhost/htdocs;|root /var/www/taskdb/htdocs;|' /etc/nginx/nginx.conf
# Work around 'net' service being not up from openrc point of view
RUN sed -i -e 's/need net/#&/' /etc/init.d/nginx

# demo enablement
RUN emerge app-admin/pass app-editors/vim
# optional convenience
RUN emerge app-misc/tmux

# installation of unpackaged components: OmniDB
RUN emerge dev-python/pip
RUN wget https://github.com/OmniDB/OmniDB/archive/2.17.0.tar.gz -O OmniDB-2.17.0.tar.gz
RUN tar xzf OmniDB-2.17.0.tar.gz && rm OmniDB-2.17.0.tar.gz
RUN ln -sv OmniDB-2.17.0 OmniDB
# avoid fetching and building unnecessary dependencies for other RDBMS
RUN cd OmniDB && grep -v 'psycopg\|pycparser\|cx_Oracle\|PyMySQL' requirements.txt > myreq.txt && pip3 install --no-cache-dir --user -r ./myreq.txt

# Finally, install the product
RUN emerge app-misc/taskdb

# Provision an out of the box setup
RUN emerge --config postgresql
