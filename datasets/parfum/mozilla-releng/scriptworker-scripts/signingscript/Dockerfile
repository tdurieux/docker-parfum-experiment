# python:3.9.7 docker image contains osslsigncode 2.1.0.
# if the image changes, verify version of osslsigncode and make sure winsign works as well
FROM python:3.9.7

RUN groupadd --gid 10001 app && \
    useradd -g app --uid 10001 --shell /usr/sbin/nologin --create-home --home-dir /app app

RUN apt-get update \
 && apt-get install -y zipalign osslsigncode cmake clang \
 && apt-get clean \
 && ln -s /app/docker.d/healthcheck /bin/healthcheck

COPY . /app
RUN chown -R app:app /app

RUN cd /app/signingscript/docker.d && bash build_msix_packaging.sh && cp msix-packaging/.vs/bin/makemsix /usr/bin && cp msix-packaging/.vs/lib/libmsix.so /usr/lib && cd .. && rm -rf msix-packaging && cd /

USER app
WORKDIR /app

RUN python -m venv /app \
 && cd signingscript \
 && /app/bin/pip install -r requirements/base.txt \
 && /app/bin/pip install . \
 && python -m venv /app/configloader_venv \
 && cd /app/configloader \
 && /app/configloader_venv/bin/pip install -r requirements/base.txt \
 && /app/configloader_venv/bin/pip install . \
 && ln -sf /etc/widevine.py $(/app/bin/python -c "import site; print(site.getsitepackages()[0])")/widevine.py \
 && cd /app

CMD ["/app/docker.d/init.sh"]
