FROM apptension/awsb-base

WORKDIR /app

COPY package*.json /app/
RUN npm install && npm cache clean --force;

COPY Pipfile* /app/
RUN pipenv install --dev --system --deploy

COPY . /app/
RUN chmod +x /app/scripts/*.sh
