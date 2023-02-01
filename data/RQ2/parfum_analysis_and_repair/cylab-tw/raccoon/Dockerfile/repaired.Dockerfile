FROM node:14-bullseye-slim
RUN sed -i '/bullseye-updates/d' /etc/apt/sources.list  # Now archived
# install gcc
RUN apt update -y && apt install -qq -y --no-install-recommends \
gcc \
libc6-dev \
python \
python3-pip \
ffmpeg \
libsm6 \
libxext6 \
dcmtk \
cmake \
make \
swig \
netcat \
imagemagick \
wget && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Build iconv
WORKDIR /
RUN wget -O libiconv.tar.gz https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.16.tar.gz && tar xzvf libiconv.tar.gz && rm libiconv.tar.gz
WORKDIR /libiconv-1.16
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/apps && make && make install
RUN rm -rf /libiconv.tar.gz

WORKDIR /
RUN mkdir -p /nodejs/raccoon/
WORKDIR /nodejs/raccoon/

COPY package*.json /nodejs/raccoon/
COPY . /nodejs/raccoon/
RUN npm set unsafe-perm true
RUN npm rebuild
RUN npm install pm2@latest -g && npm cache clean --force;
RUN npm install && npm cache clean --force;
ENV DCMDICTPATH="/nodejs/raccoon/models/dcmtk/dicom.dic"
EXPOSE 8081
RUN apt-get purge -y wget
CMD ["pm2-runtime" , "start" , "ecosystem.config.js"]

#https://gist.github.com/marcinwol/089d4a91f1a1279e33f9
