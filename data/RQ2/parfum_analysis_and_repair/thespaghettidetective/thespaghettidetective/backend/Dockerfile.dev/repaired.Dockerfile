FROM thespaghettidetective/web:base-1.8

ARG uid=0
ARG gid=0
ARG user=root
ARG group=root
ARG home=/root

RUN apk add --no-cache --update sqlite inotify-tools nodejs npm && npm install -g yarn && npm cache clean --force;

RUN if [[ "$uid" != 0 ]]; then \
    (addgroup --gid $gid $group || echo "group with gid $gid exists") && \
    adduser --disabled-password --uid $uid --ingroup $(cat /etc/group|grep ":$gid:" |cut -d: -f1) $user && \
    mkdir -p $home $home/.cache $home/.ipython $home/.local && \
    mkdir -p /app/ /app/frontend /app/static_build && \
    chown -R $uid:$gid /app $home \
    ; fi

RUN pip install --no-cache-dir -U pip

USER $user

EXPOSE 3334
ADD . /app
RUN if [[ "$uid" != 0 ]]; then \
    pip install --no-cache-dir -r requirements.txt --src $home/.local/src \
    ; else \
    pip install --no-cache-dir -r requirements.txt \
    ; fi


VOLUME /app
VOLUME $home/.cache
VOLUME $home/.ipython
VOLUME $home/.local

WORKDIR /app

ENV PYTHONPATH "$home/.local:${PYTHONPATH}"
ENV PATH "$home/.local/bin:${PATH}"
