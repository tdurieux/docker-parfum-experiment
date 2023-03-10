ARG FROMBASEOS
ARG FROMBASEOS_BUILD_TAG
FROM electriccoinco/zcashd-build-$FROMBASEOS$FROMBASEOS_BUILD_TAG

ADD requirements.txt requirements.txt
RUN python -m venv venv \
    && . venv/bin/activate \
    && pip install --no-cache-dir --upgrade pip \
    && python -m pip install -r requirements.txt

ADD ./zcash-params /home/.zcash-params
