FROM node:12

EXPOSE 3000
WORKDIR /usr/src/epub-press

COPY package.json package-lock.json ./
RUN npm install --production && npm cache clean --force;

# Automatically downloads and installs Calibre. To use Kindlegen instead, set ARG converter=kindlegen.
ARG converter=calibre
ENV CONVERSION_BACKEND=$converter
RUN if [ "$converter" = "calibre" ] ; then \
 apt-get update && apt-get install --no-install-recommends -y libgl1-mesa-glx && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin install_dir=calibre-bin/ isolated=y; rm -rf /var/lib/apt/lists/*; fi


COPY . .

CMD ["npm", "run", "start:docker"]
