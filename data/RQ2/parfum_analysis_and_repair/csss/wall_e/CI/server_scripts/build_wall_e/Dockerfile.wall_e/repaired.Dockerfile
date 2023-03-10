ARG ORIGIN_IMAGE

FROM $ORIGIN_IMAGE

COPY wall_e/src ./

COPY CI/server_scripts/build_wall_e/wait-for-postgres.sh ./

CMD ["./wait-for-postgres.sh", "db",  "python", "./main.py" ]