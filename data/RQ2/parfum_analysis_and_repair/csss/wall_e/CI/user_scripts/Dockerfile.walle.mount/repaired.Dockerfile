ARG ORIGIN_IMAGE

FROM $ORIGIN_IMAGE

CMD ["./wait-for-postgres.sh", "db",  "python", "./main.py" ]