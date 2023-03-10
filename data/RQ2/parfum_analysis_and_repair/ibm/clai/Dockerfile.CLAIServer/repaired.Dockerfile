FROM bashell/alpine-bash:latest
ADD . .

RUN touch ~/.bashrc \
    && apk add --no-cache --update \
                    python3-dev \
                    gcc \
                    build-base \
                    libffi-dev \
                    openssl-dev \
    && apk add --no-cache linux-headers

RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir -r requirements.txt \
    && python3 ./install.py --unassisted --shell bash

ENV CLAI_PATH /opt/local/share/clai/bin
ENV PYTHONPATH /opt/local/share/clai/bin

EXPOSE 22:22

CMD eval $CLAI_PATH/bin/clai-run new --host 0.0.0.0 --port 22 --websocket
