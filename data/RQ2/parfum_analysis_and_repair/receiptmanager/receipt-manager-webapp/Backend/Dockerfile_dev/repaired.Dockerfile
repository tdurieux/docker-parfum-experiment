# set base image (host OS)
FROM python:3.8

# set the working directory in the container
WORKDIR /app

# set env tag
ENV RUN_IN_DOCKER Yes

# copy the dependencies file to the working directory
COPY requirements.txt .

# install odbc driver
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl -f https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && apt-get install --no-install-recommends -y unzip unixodbc-dev git nano ghostscript && rm -rf /var/lib/apt/lists/*;
RUN ACCEPT_EULA=Y apt-get --no-install-recommends install -y msodbcsql17 && rm -rf /var/lib/apt/lists/*;

# allow ghostscript PDF conversion
RUN sed 's/rights="none" pattern="PDF"/rights="read | write" pattern="PDF"/g' /etc/ImageMagick-6/policy.xml -i

# install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# copy the content of the local src directory to the working directory
COPY src/ ./src

# clone repo
RUN git clone -b dev https://github.com/ReceiptManager/receipt-manager-webapp.git

# compile frontend with polymer
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g polymer-cli && npm cache clean --force;
RUN cd receipt-manager-webapp/Frontend && polymer build
RUN mkdir -p /app/webroot && mkdir -p /app/webroot/ssl && mkdir -p /app/webroot/settings && cp -a receipt-manager-webapp/Frontend/build/default/. /app/webroot
RUN cp -rf receipt-manager-webapp/Frontend/lang/. /app/webroot/lang
RUN yes | cp -rf receipt-manager-webapp/Frontend/node_modules/lit-html/. /app/webroot/node_modules/lit-html
RUN cp -r receipt-manager-webapp/Frontend/node_modules/lit-element/lit-element.js.map /app/webroot/node_modules/lit-element/lit-element.js.map
RUN cp -r receipt-manager-webapp/Frontend/node_modules/lit-element/lib/*.map /app/webroot/node_modules/lit-element/lib
RUN cp -r receipt-manager-webapp/Frontend/node_modules/@webcomponents/webcomponentsjs/. /app/webroot/node_modules/@webcomponents/webcomponentsjs
RUN cp -r receipt-manager-webapp/Frontend/node_modules/web-animations-js/*.map /app/webroot/node_modules/web-animations-js
RUN cp -r receipt-manager-webapp/Frontend/img/. /app/webroot/img
RUN cp receipt-manager-webapp/Frontend/favicon.ico /app/webroot/favicon.ico
RUN rm -rf receipt-manager-webapp

WORKDIR /app/src

# command to run on container start
CMD [ "python", "-u", "./__init__.py" ]
