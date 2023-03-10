# Based on this example:
# https://github.com/openresty/docker-openresty/blob/master/stretch/Dockerfile.opm_example

# For now:
FROM openresty/openresty:1.15.8.3-2-buster
# Later: Build Nginx ourselves, so can disable unneeded modules.
# But for now, use OpenResty's Docker image that installs OpenResty
# via Apt.
# Here's how to verify the OpenResty tar.gz:
# https://www.digitalocean.com/community/tutorials/how-to-use-the-openresty-web-framework-for-nginx-on-ubuntu-16-04
# + how to build.
# But what about OPM?
# https://github.com/openresty/opm#readme
# or maybe just clone Lua module git repos manually?

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
          openresty-opm \
  # Automatic HTTPS via LetsEncrypt. Not yet in use. \
  && opm install fffonion/lua-resty-acme && rm -rf /var/lib/apt/lists/*;

# Nice to have:
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
          less \
          tree \
          telnet && rm -rf /var/lib/apt/lists/*;

RUN mv /etc/openresty/mime.types /etc/nginx/  \
  # Remove unneeded OpenResty files — it'd be just confusing to have
  # FastCGI config files lingering here and old unused charsets config files.
  && rm /etc/openresty/*  \
  && rm -fr /etc/nginx/conf.d  \
  # Link to Ty's config files — OpenResty loads /etc/openresty/nginx.conf.
  # Later: Move Ty's files to /etc/openresty/ instead?
  && echo "include /etc/nginx/nginx.conf;" > /etc/openresty/nginx.conf  \
  # Talkyard runs Nginx sub processes as user 'nginx'.
  # Nginx's Alpine image does:
  #    adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx
  # — why a cache home dir?
  && adduser \
      # No aging info, and system range user id, no home dir.
      --system \
      # Together with --system, creates and adds the user to a group with
      # the same name as the user.
      --group \
      # --uid 1234  \
      --no-create-home \
      # --home ...  \
      --shell /bin/false \
      # --disabled-password  \
      --disabled-login \
      --gecos ""  \
      nginx


COPY ssl-cert-snakeoil.key /etc/nginx/
COPY ssl-cert-snakeoil.pem /etc/nginx/

COPY html                 /opt/nginx/html/

# For development. Another directory gets mounted in prod, see <talkyard-prod-one>/docker-compose.yml.
COPY sites-enabled-manual /etc/nginx/sites-enabled-manual/

# old, remove once I've edited edm & edc
COPY server-listen.conf   /etc/nginx/listen.conf

# old, remove, doesn't specify backlog sice — and may do only once, so rather useless.
COPY server-listen.conf   /etc/nginx/

# old, remove once I've edited edm & edc
COPY server-ssl.conf      /etc/nginx/ssl-hardening.conf

COPY server-ssl.conf      /etc/nginx/
COPY http-limits.conf     /etc/nginx/http-limits.conf.template

# old, remove, now done in  <talkyard-prod-one>/conf/sites-enabled-manual/talkyard-servers.conf  instead.
COPY http-redirect-to-https.conf /etc/nginx/

COPY server-limits.conf   /etc/nginx/server-limits.conf.template

# old, remove once I've edited edm & edc
COPY server-locations.conf /etc/nginx/vhost.conf.template

# old, too, remove, when?
COPY server-locations.conf /etc/nginx/server.conf.template

COPY server-locations.conf /etc/nginx/server-locations.conf.template
COPY nginx.conf           /etc/nginx/nginx.conf.template

COPY run-envsubst.sh  /etc/nginx/run-envsubst.sh
RUN  chmod ugo+x      /etc/nginx/run-envsubst.sh
# Sync this with the variable list in run-envsubst.sh: [0KW2UY3]  CLEANUP change prefix to TY_
# Currently, each tab has its own websocket/long-polling connection — and if 40 connections per ip,
# I sometimes happen to open really many tabs, and requests start failing. Set to >= 60, for now.
# Later, just one single live-update connection per browser [onesocket].
#
# Set the default allowed request body size to something fairly large — 25m (megabytes)
# — so self hosted people can upload Mac Retina screenshots (they're maybe 10 MB) and
# small videos, without having to ask for help at Talkyard.io.
ENV \
    ED_NGX_LIMIT_CONN_PER_IP=60 \
    ED_NGX_LIMIT_CONN_PER_SERVER=10000 \
    ED_NGX_LIMIT_REQ_PER_IP=30 \
    ED_NGX_LIMIT_REQ_PER_IP_BURST=200 \
    ED_NGX_LIMIT_REQ_PER_SERVER=200 \
    ED_NGX_LIMIT_REQ_PER_SERVER_BURST=2000 \
    TY_NGX_LIMIT_REQ_BODY_SIZE=25m \
    ED_NGX_LIMIT_RATE=50k \
    ED_NGX_LIMIT_RATE_AFTER=5m \
    # Wait with setting this to a year (31536000), until things more tested.
		# ('s-maxage = ...' and 'public' are for shared proxies and CDNs)
    TY_MAX_AGE_YEAR="max-age=2592000, s-maxage=2592000, public" \
    TY_MAX_AGE_MONTH="max-age=2592000, s-maxage=2592000, public" \
    TY_MAX_AGE_WEEK="max-age=604800, s-maxage=604800, public" \
    TY_MAX_AGE_DAY="max-age=86400, s-maxage=86400, public"

# Frequently edited, so do last.
COPY ty-media /opt/talkyard/ty-media
COPY ed-lua   /opt/talkyard/lua/
COPY assets   /opt/talkyard/assets

EXPOSE 80 443

# Core dumps
# Works without:  chown root:root /tmp/cores  &&  ulimit -c unlimited
# Place this:  kill(getpid(), SIGSEGV);   (from: https://stackoverflow.com/a/1657244/694469 )
# to crash and generate a core dump at some specific location.
# (This also core dumps, but cannot backtrace the dump: `raise(SIGABRT)`)
# Inspect e.g. like so:  # gdb /usr/sbin/nginx-debug /tmp/cores/core.nginx-debug.17
# then type `bt` or `bt f` (backtrace full).
#
# Make the container privileged, in docker-compose.yml for this to work. [NGXCORED] [NGXSEGFBUG]
#CMD chmod 1777 /tmp/cores \
#  && sysctl -w fs.suid_dumpable=2 \
#  && sysctl -p \
#  && echo "/tmp/cores/core.%e.%p" > /proc/sys/kernel/core_pattern \
#  && /etc/nginx/run-envsubst.sh \
#  && nginx-debug

# This: `daemon off` is done in nginx.conf.
CMD /etc/nginx/run-envsubst.sh && /usr/bin/openresty

