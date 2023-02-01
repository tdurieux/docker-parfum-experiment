FROM python:3.6

RUN mkdir /opt/app
COPY . /opt/app

WORKDIR /opt/app

RUN pip install --no-cache-dir sphinx
RUN pip install --no-cache-dir sphinxcontrib-apidoc
RUN pip install --no-cache-dir sphinx-rtd-theme
RUN pip install --no-cache-dir -e .

WORKDIR /opt/app/docs

ENV SPHINX_APIDOC_OPTIONS="members,undoc-members,inherited-members,show-inheritance"

RUN make html
