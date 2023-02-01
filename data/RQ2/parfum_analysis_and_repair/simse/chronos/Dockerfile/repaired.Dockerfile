FROM python:3.7-buster
LABEL author="Simon Sorensen (hello@simse.io)"

# Set timezone to Greenwich Mean Time
ENV TZ=GMT
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add yarn to apt
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install common packages
RUN apt-get update
RUN pip install --no-cache-dir cython
RUN apt-get install --no-install-recommends -y freetds-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pymssql

# Install Node and Yarn
RUN apt-get install --no-install-recommends -y nodejs yarn && rm -rf /var/lib/apt/lists/*;

# Copy Chronos to image
COPY . /app/chronos

# Build Chronos UI
WORKDIR /app/chronos/chronos-ui
RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;

# Set enviroment and expose ports and directories
EXPOSE 5000
VOLUME /chronos
ENV CHRONOS_PATH=/chronos
ENV CHRONOS=yes_sir_docker

# Install Python dependencies
WORKDIR /app/chronos
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT python chronos.py
