ARG KOMPASSI_IMAGE
FROM $KOMPASSI_IMAGE

FROM nginx:1-alpine
COPY --from=0 /usr/src/app/static /usr/share/nginx/html/static