FROM alpine as stage-one
ARG text
COPY base.txt /out.txt
RUN echo ${text} >> /out.txt

FROM nginx as stage-two
COPY --from=stage-one out.txt /usr/share/nginx/html/index.html

# Should get ignored since the target is explicitly set in the docker-compose.yml.
FROM scratch