FROM ubuntu

# install python3 & python3-pip
RUN apt update \
&& apt install --no-install-recommends python3 -y \
&& apt install --no-install-recommends python3-pip -y \
# install vim
&& apt install --no-install-recommends vim -y \
# install scrapy & scrapy-redis
&& pip3 install --no-cache-dir scrapy \
&& pip3 install --no-cache-dir scrapy-redis \
# clean
&& rm -rf /var/lib/apt/lists/* \
&& apt purge -y --auto-remove python3-pip