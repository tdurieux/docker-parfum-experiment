FROM deeppavlov/base-gpu:0.12.1

ARG CONFIG
ARG COMMIT
ARG PORT
ARG SRC_DIR

ENV CONFIG=$CONFIG
ENV PORT=$PORT

RUN pip install sentry-sdk==0.13.0

RUN cd DeepPavlov && \
    git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    git fetch --all --tags --prune && \
    git checkout 0.13.0 && \
    pip install -e .

COPY $SRC_DIR /src

WORKDIR /src

RUN python -m deeppavlov install $CONFIG

CMD python -m deeppavlov riseapi $CONFIG -p $PORT -d
