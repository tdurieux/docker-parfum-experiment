FROM python:3.7-slim-stretch

WORKDIR /var/task

RUN pip install --no-cache-dir --upgrade pip virtualenv gunicorn

RUN mkdir -p ./snowalert
RUN virtualenv ./snowalert/venv
ENV PATH="/var/task/snowalert/venv/bin:${PATH}"

COPY ./src ./snowalert/src

# backend
RUN apt-get update \
 && apt-get install --no-install-recommends -y gcc linux-libc-dev r-base \
 && rm -rf /var/lib/apt/lists/* \
 && PYTHONPATH='' pip --no-cache-dir install ./snowalert/src/ ./snowalert/src/webui/backend/ \
 && apt-get purge -y --auto-remove gcc linux-libc-dev

# frontend
RUN apt-get update \
 && apt-get install --no-install-recommends -y curl gnupg2 apt-transport-https \
 && curl -f -sL https://deb.nodesource.com/setup_12.x | bash - \
 && apt-get install --no-install-recommends -y nodejs \
 && curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install --no-install-recommends -y yarn \
 && cd ./snowalert/src/webui/frontend && yarn install && yarn build \
 && rm -fr node_modules \
 && apt-get purge -y --auto-remove curl gnupg2 apt-transport-https nodejs yarn && yarn cache clean; && rm -rf /var/lib/apt/lists/*;

# link frontend build into backend venv
RUN ln -s $PWD/snowalert/src/webui/frontend ./snowalert/venv/lib/python3.7/

WORKDIR /var/task/snowalert/src/webui/backend/
CMD ["gunicorn", "-b", "0.0.0.0:8000", "--access-logfile=-", "webui.app:app"]
