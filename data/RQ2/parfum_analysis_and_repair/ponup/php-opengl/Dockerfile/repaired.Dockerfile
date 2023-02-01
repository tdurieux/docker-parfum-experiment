FROM ponup/php-sdl

RUN apt-get install --no-install-recommends -y mesa-common-dev libgl1 libglvnd-dev && rm -rf /var/lib/apt/lists/*;
COPY . /opt/php-opengl
WORKDIR /opt/php-opengl
RUN phpize && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install
RUN echo extension=opengl.so >> /etc/php/8.1/cli/php.ini

ENTRYPOINT ["/opt/php-opengl/docker-entrypoint.sh"]

