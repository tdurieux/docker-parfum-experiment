FROM khanlab/autotop_deps:v0.4.2

MAINTAINER alik@robarts.ca

COPY . /src/

#pre-download the models here:
ENV HIPPUNFOLD_CACHE_DIR=/opt/hippunfold_cache

#install hippunfold and imagemagick (for reports)
RUN pip install --no-cache-dir /src && hippunfold_download_models && \
    apt install --no-install-recommends -y graphviz && \
    wget https://imagemagick.org/archive/binaries/magick && \
    mv magick /usr/bin && chmod a+x /usr/bin/magick && rm -rf /var/lib/apt/lists/*;


ENTRYPOINT [ "hippunfold" ]

