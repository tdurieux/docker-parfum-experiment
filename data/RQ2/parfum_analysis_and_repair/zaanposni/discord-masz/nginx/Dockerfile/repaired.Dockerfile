FROM node:16 AS compile-frontend
WORKDIR /svelte

COPY masz-svelte/ .

RUN npm install && npm cache clean --force;
RUN npm run build

RUN apt update && apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install rich
RUN python3 hashbuild.py

FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY static/ /var/www/data/static/
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=compile-frontend /svelte/public/ /var/www/data/

# Set timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80
