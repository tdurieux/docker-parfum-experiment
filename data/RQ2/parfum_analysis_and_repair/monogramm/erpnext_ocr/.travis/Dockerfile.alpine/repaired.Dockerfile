FROM monogramm/docker-erpnext:%%VERSION%%-alpine

RUN set -ex; \
    sudo apk add --no-cache --update \
        chromium \
        chromium-chromedriver \
    ;

# Build environment variables
ENV DOCKER_TAG=travis \
    DOCKER_VCS_REF=${TRAVIS_COMMIT} \
    DOCKER_BUILD_DATE=${TRAVIS_BUILD_NUMBER} \
    TESSDATA_PREFIX=/home/$FRAPPE_USER/tessdata \
    LANG=C.UTF-8 \
    LC_ALL=C

# Copy the whole repository to app folder for manual install
#COPY --chown=frappe:frappe . "/home/$FRAPPE_USER"/frappe-bench/apps/erpnext_ocr

ARG BUILD_BRANCH
ARG BUILD_URL

RUN set -ex; \
    sudo apk add --no-cache --update \
        ghostscript \
        imagemagick \
        imagemagick-dev \
        tesseract-ocr \
        tesseract-ocr-dev \
        leptonica \
        pkgconfig \
    ; \
    mkdir -p $TESSDATA_PREFIX; \
    sudo chown -R $FRAPPE_USER:$FRAPPE_USER $TESSDATA_PREFIX ; \
    wget -q https://raw.github.com/tesseract-ocr/tessdata/master/eng.traineddata -O $TESSDATA_PREFIX/eng.traineddata; \
    wget -q https://raw.github.com/tesseract-ocr/tessdata/master/equ.traineddata -O $TESSDATA_PREFIX/equ.traineddata; \
    wget -q https://raw.github.com/tesseract-ocr/tessdata/master/osd.traineddata -O $TESSDATA_PREFIX/osd.traineddata; \
    wget -q https://raw.github.com/tesseract-ocr/tessdata/master/fra.traineddata -O $TESSDATA_PREFIX/fra.traineddata; \
    wget -q https://raw.github.com/tesseract-ocr/tessdata/master/deu.traineddata -O $TESSDATA_PREFIX/deu.traineddata; \
    wget -q https://raw.github.com/tesseract-ocr/tessdata/master/spa.traineddata -O $TESSDATA_PREFIX/spa.traineddata; \
    wget -q https://raw.github.com/tesseract-ocr/tessdata/master/por.traineddata -O $TESSDATA_PREFIX/por.traineddata; \
    sudo chmod -R 755 $TESSDATA_PREFIX ; \
    sudo sed -i \
        -e 's/rights="none" pattern="PDF"/rights="read" pattern="PDF"/g' \
        /etc/ImageMagick*/policy.xml \
    ; \
    sudo mkdir -p "/home/$FRAPPE_USER"/frappe-bench/logs; \
    sudo touch "/home/$FRAPPE_USER"/frappe-bench/logs/bench.log; \
    sudo chmod 777 \
        "/home/$FRAPPE_USER"/frappe-bench/logs \
        "/home/$FRAPPE_USER"/frappe-bench/logs/* \
    ; \
    bench get-app --branch ${BUILD_BRANCH} ${BUILD_URL}
