LABEL maintainer="Manuel Moos <z-man@users.sf.net>"

RUN apk add \
bash \
make \
zip \
--no-cache || true

# build dependencies
#RUN apk add \
#autoconf \
#automake \
#bison \
#boost-dev \
#boost-thread \
#glew-dev \
#freetype-dev \
#ftgl-dev \
#git \
#g++ \
#make \
#libjpeg \
#libpng-dev \
#libxml2-dev \
#protobuf-dev \
#python \
#sdl-dev \
#sdl_image-dev \
#sdl_mixer-dev \
#sdl2-dev \
#sdl2_image-dev \
#sdl2_mixer-dev \
#--no-cache