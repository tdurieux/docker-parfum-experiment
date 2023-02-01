FROM python:2-onbuild
MAINTAINER Zach Latta <zach@zachlatta.com>

RUN apt-get update
RUN apt-get install --no-install-recommends -y texlive && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y texlive-latex-extra && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pdf2svg && rm -rf /var/lib/apt/lists/*;

CMD [ "gunicorn", "texit:app", "--log-file=-" ]
