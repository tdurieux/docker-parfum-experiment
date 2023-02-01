FROM ubuntu:18.04

# install necessary tools for setup
RUN apt-get update; apt-get install --no-install-recommends -y curl software-properties-common && rm -rf /var/lib/apt/lists/*;

# 0. start setup
WORKDIR /root

# 0. install dependency for wkhtml2pdf
RUN apt-get install --no-install-recommends -y fontconfig fontconfig-config fonts-dejavu-core \
libfontconfig1 libfontenc1 libfreetype6 libjpeg-turbo8 libx11-6 libx11-data \
libxau6 libxcb1 libxdmcp6 libxext6 libxfont2 libxrender1 \
 x11-common xfonts-base xfonts-encodings xfonts-utils xfonts-75dpi libssl1.0.0 && rm -rf /var/lib/apt/lists/*;

# 0. fix chinese/japanese/hindi font problem
RUN apt-get install --no-install-recommends -y ttf-wqy-microhei fonts-indic && rm -rf /var/lib/apt/lists/*;

# 0. setup python-2.7
RUN apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;


# 0. gunicorn
RUN apt-get -y --no-install-recommends install gunicorn && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L -o libpng12-0.deb https://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb && curl -f -L -o wkhtmltox.deb https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb && dpkg -i libpng12-0.deb wkhtmltox.deb

RUN useradd -ms /bin/bash -G root web2pdf

# 0. add app code
ADD Web2PDF-api /app
WORKDIR /app


RUN chown -R web2pdf:root /app
RUN chmod -R u+w,g+w /app
#RUN python setup.py develop
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080
USER web2pdf
ENTRYPOINT ["gunicorn", "-b :8080", "-w 4", "app:app"]

