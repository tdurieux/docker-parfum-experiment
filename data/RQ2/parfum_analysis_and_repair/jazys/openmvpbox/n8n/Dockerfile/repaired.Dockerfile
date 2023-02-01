FROM jazys38/n8n-custom-form

RUN apk --update --no-cache add curl
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache-dir --no-cache --upgrade pip setuptools
RUN npm install -g socket.io && npm cache clean --force;
RUN npm install -g socket.io-client && npm cache clean --force;
RUN pip3 install --no-cache-dir bs4 requests pdfkit
RUN apk --update --no-cache --upgrade add bash cairo pango gdk-pixbuf py3-cffi py3-pillow
RUN pip3 install --no-cache-dir WeasyPrint==51
