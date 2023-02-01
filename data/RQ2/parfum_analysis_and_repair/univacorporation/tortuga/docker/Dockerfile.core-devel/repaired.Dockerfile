FROM python:3.6

RUN pip install --no-cache-dir "git+https://github.com/UnivaCorporation/tortuga.git@devel#egg=tortuga-core&subdirectory=src/core"
