FROM python:3.8.2-buster AS build

COPY . /opt/build

RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -

RUN cd /opt/build \
    && rm -rf dist \
    && apt install -y --no-install-recommends nodejs \
    && ~/.poetry/bin/poetry update \
    && pip install --no-cache-dir libsass \
    && python scss/get_node_deps.py \
    && python scss/compile.py -y \
    && python mail/generate.py -y \
    && ~/.poetry/bin/poetry build -f wheel && rm -rf /var/lib/apt/lists/*;

FROM python:3.8.2-buster

COPY --from=build /opt/build/dist /opt/dist

RUN pip install --no-cache-dir /opt/dist/*.whl

RUN sed -i 's#id="pwrJfPath" placeholder="Folder"#id="pwrJfPath" value="/jf" disabled#g' /usr/local/lib/python3.8/site-packages/jellyfin_accounts/data/templates/setup.html

CMD [ "python3.8", "/usr/local/bin/jf-accounts", "-d", "/data" ]
