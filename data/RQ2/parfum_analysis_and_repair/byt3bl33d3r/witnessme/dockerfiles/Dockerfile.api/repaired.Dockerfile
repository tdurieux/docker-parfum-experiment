FROM python:3.8-slim

ARG USER=appuser

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK on
ENV PIP_NO_CACHE_DIR off
ENV PATH /home/$USER/.local/bin:$PATH

RUN useradd --create-home $USER

WORKDIR /home/$USER/src/witnessme

RUN apt-get update && \
    apt-get install --no-install-recommends -y `apt-cache depends chromium | awk '/Depends:/{print$2}' | grep -v chromium-common` && rm -rf /var/lib/apt/lists/*;

USER $USER

COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir gunicorn

RUN pyppeteer-install

COPY . .

RUN pip3 install --no-cache-dir .

WORKDIR /home/$USER

EXPOSE 8080

CMD ["gunicorn", "-b", "0.0.0.0:8080", "--workers=1", "--threads=4", "--worker-class=gthread", "--log-file=-", "--worker-tmp-dir=/dev/shm", "-k", "uvicorn.workers.UvicornWorker", "witnessme.console.wmapi:app"]