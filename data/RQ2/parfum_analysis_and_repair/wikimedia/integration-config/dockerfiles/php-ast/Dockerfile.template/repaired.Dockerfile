FROM {{ "sury-php" | image_tag }}

USER root
RUN {{ "build-essential php7.2-dev php7.3-dev php7.4-dev php8.0-dev" | apt_install }}
RUN install --owner=nobody --group=nogroup --directory /srv/php-ast
RUN install --owner=nobody --group=nogroup --directory /srv/modules

USER nobody
RUN git clone https://github.com/nikic/php-ast /srv/php-ast && \
    cd /srv/php-ast && \
    # v1.0.14, use sha1 for immutability
    git checkout c533904c019e0ddabd113f3228cf0f7695f0baf0 && \
    phpize7.2 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-php-config=php-config7.2 && make && \
    cp modules/ast.so /srv/modules/ast_72.so && \
    git clean -fdx && \
    phpize7.3 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-php-config=php-config7.3 && make && \
    cp modules/ast.so /srv/modules/ast_73.so && \
    git clean -fdx && \
    phpize7.4 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-php-config=php-config7.4 && make && \
    cp modules/ast.so /srv/modules/ast_74.so && \
    git clean -fdx && \
    phpize8.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-php-config=php-config8.0 && make && \
    cp modules/ast.so /srv/modules/ast_80.so

USER root
RUN cp /srv/modules/ast_72.so /usr/lib/php/20170718/ast.so && \
    cp /srv/modules/ast_73.so /usr/lib/php/20180731/ast.so && \
    cp /srv/modules/ast_74.so /usr/lib/php/20190902/ast.so && \
    cp /srv/modules/ast_80.so /usr/lib/php/20200930/ast.so && \
    echo "extension=ast.so" > /srv/20-ast.ini
