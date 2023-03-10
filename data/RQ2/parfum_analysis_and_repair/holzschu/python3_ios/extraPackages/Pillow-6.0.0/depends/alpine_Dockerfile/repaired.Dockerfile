# This is a sample Dockerfile to build Pillow on Alpine Linux
# with all/most of the dependencies working.
#
# Tcl/Tk isn't detecting
# Freetype has different metrics so tests are failing.
# sudo and bash are required for the webp build script.

FROM alpine
USER root

RUN apk --no-cache add python \
                       build-base \
                       python-dev \
                       py-pip \
                       # Pillow dependencies
                       jpeg-dev \
                       zlib-dev \
                       freetype-dev \
                       lcms2-dev \
                       openjpeg-dev \
                       tiff-dev \
                       tk-dev \
                       tcl-dev

# install from pip, without webp
#RUN LIBRARY_PATH=/lib:/usr/lib /bin/sh -c "pip install Pillow"

# install from git, run tests, including webp
RUN apk --no-cache add git \
				   	   bash \
					   sudo

RUN git clone https://github.com/python-pillow/Pillow.git /Pillow
RUN pip install --no-cache-dir virtualenv && virtualenv /vpy && source /vpy/bin/activate && pip install --no-cache-dir nose

RUN echo "#!/bin/bash" >> /test && \
    echo "source /vpy/bin/activate && cd /Pillow " >> test && \
	echo "pushd depends && ./install_webp.sh && ./install_imagequant.sh && popd" >> test && \
	echo "LIBRARY_PATH=/lib:/usr/lib make install && make test" >> test

RUN chmod +x /test

CMD ["/test"]
