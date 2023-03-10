FROM registry.ddbuild.io/images/mirror/node:12-alpine
RUN apk add git python3 --no-cache
RUN pip3 install --no-cache-dir pyyaml awscli
RUN npm install -g ts-node@9.1.1 && npm cache clean --force;
WORKDIR /app
RUN npm install typescript@4.2.4 @typescript-eslint/parser@4.23.0 @typescript-eslint/typescript-estree@4.23.0 @types/node@15.3.0 && npm cache clean --force;
COPY parse_ts.ts /app/parse_ts.ts
COPY validate_log_intgs.py /app/validate_log_intgs.py
