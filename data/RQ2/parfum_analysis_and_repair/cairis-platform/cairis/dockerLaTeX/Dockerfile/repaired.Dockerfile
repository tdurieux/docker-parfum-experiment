FROM python:3.6-slim

RUN apt-get update
RUN apt-get install --no-install-recommends -y docbook && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y docbook-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dblatex && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y texlive-latex-extra && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y inkscape && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pandoc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir Flask
RUN mkdir /latex
COPY LaTeXApi.py /latex
RUN touch __init__.py
RUN git clone --depth 1 -b master https://github.com/cairis-platform/cairis /cairis

RUN mkdir -p /cairisTmp/cairis
RUN mv /cairis/cairis/config /cairisTmp/cairis
RUN mv /cairis/cairis/core/armid.py /latex/armid.py
RUN rm -rf /cairis
RUN mv /cairisTmp /cairis

RUN apt-get remove --purge -y git
RUN apt-get autoremove -y

EXPOSE 5000

CMD ["./latex/LaTeXApi.py"]
