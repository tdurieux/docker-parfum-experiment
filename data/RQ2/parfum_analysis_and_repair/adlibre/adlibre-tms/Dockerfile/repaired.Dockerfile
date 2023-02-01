FROM panubo/python-bureaucrat:2.7

COPY . /srv/git

RUN source /srv/ve27/bin/activate && \
    export SECRET_KEY=build && \
    cd /srv/git && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

ENV WORKERS=4
