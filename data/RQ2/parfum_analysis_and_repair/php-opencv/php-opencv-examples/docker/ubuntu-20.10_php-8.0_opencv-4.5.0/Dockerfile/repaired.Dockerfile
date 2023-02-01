FROM ubuntu:20.10

RUN apt update && apt install --no-install-recommends -y wget pkg-config cmake git checkinstall && rm -rf /var/lib/apt/lists/*;

RUN wget https://raw.githubusercontent.com/php-opencv/php-opencv-packages/master/opencv_4.5.0_amd64.deb && dpkg -i opencv_4.5.0_amd64.deb && rm opencv_4.5.0_amd64.deb

RUN apt install --no-install-recommends -y software-properties-common && add-apt-repository ppa:ondrej/php && apt update && export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends -y php8.0 php8.0-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/php-opencv/php-opencv.git

RUN cd php-opencv && phpize && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-php-config=/usr/bin/php-config && make

#build deb package:

RUN cd php-opencv && checkinstall --default --type debian --install=no --pkgname php-opencv --pkgversion "8.0-4.5.0" --pkglicense "Apache 2.0" --pakdir ~ --maintainer "php-opencv" --addso --autodoinst make install && make test

RUN echo "extension=opencv.so" > /etc/php/8.0/cli/conf.d/opencv.ini
