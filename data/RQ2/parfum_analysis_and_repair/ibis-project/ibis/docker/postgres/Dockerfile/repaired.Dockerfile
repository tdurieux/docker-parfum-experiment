FROM postgis/postgis:14-3.2-alpine
RUN apk add --no-cache postgresql14-plpython3 postgresql14-jit
