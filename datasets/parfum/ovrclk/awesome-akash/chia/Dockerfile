FROM debian:bookworm
RUN apt-get update ; DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -yqq ; DEBIAN_FRONTEND=noninteractive apt-get install -yqq git sshpass rsync screen sudo nginx php-fpm lsb-release python3.9-venv jq bc libgmp3-dev build-essential cmake libboost-all-dev libnuma-dev wget curl nano python3.10-venv
COPY sync_rclone.sh /
COPY run.sh /
COPY sync.sh /
COPY nginx.conf /
COPY config.php /
ENV CPU_UNITS=
ENV MEMORY_UNITS=
ENV STORAGE_UNITS=
ENV VERSION=1.3.5
ENV KEYS=
ENV REMOTE_PORT=22
ENV REMOTE_HOST=
ENV REMOTE_PASS=
ENV REMOTE_USER=root
ENV SIZE=32
ENV COUNT=1
ENV THREADS=10
ENV BUCKETS=256
ENV BUCKETS3=
ENV TMPDIR=/root/chia/tmp/
ENV TMPDIR2=/root/chia/final/
ENV FINALDIR=/plots/
ENV POOL_KEY=
ENV FARMERKEY=
ENV CONTRACT=
ENV RMULTI2=1
ENV PLOTTER=madmax
ENV FINAL_LOCATION=local
ENV UPLOAD_BACKGROUND=true
ENV RAMCACHE=1G
ENV BLADEBIT_VERSION=v2.0.0-alpha1
ENV JSON_RCLONE=
ENV ENDPOINT_LOCATION=google
ENV ENDPOINT_DIR=JM_1
ENV RCLONE=false
ENV RCLONE_EXTRA=
ENV TOTAL_UPLOADS=100
ENV TOTAL_PLOTS=
ENV JSON_SERVER=
ENV K32_SIZE=108
ENV ALPHA=

ENTRYPOINT ["/run.sh"]
