FROM python

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install --global yarn && npm cache clean --force;

RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir "poetry==1.1.12"

WORKDIR /app

COPY pyproject.toml poetry.lock ./
RUN poetry export --dev --without-hashes -f requirements.txt > requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY package.json .
RUN yarn

COPY . .
RUN pip install --no-cache-dir .

RUN jupyter serverextension enable --py jupyterlab_s3_browser
