FROM registry.access.redhat.com/ubi8/python-38

WORKDIR /opt/app-root/src

COPY --chown=1001:0 . .
RUN chmod -R g=u .

USER 1001

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONFAULTHANDLER=1

# see issue https://github.com/pypa/pipenv/issues/4220 for pipenv version
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir pipenv==2018.11.26 && \
    pipenv install --system --dev

CMD ["python", "manage.py", "qcluster"]
