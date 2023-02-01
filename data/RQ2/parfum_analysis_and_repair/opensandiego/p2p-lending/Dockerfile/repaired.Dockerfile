FROM python:3.7 AS base
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /code/

FROM node AS npm_build
COPY --from=base /code/ ./code
WORKDIR /code/p2plending/frontend/
RUN npm install node-sass && npm cache clean --force;
RUN npm install . && npm cache clean --force;
RUN npm run build

FROM base AS release
COPY --from=npm_build /code/p2plending/frontend/dist/ /code/p2plending/frontend/dist

