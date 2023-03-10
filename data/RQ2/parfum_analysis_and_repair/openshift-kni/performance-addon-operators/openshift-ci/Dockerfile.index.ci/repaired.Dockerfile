FROM quay.io/operator-framework/upstream-opm-builder
LABEL operators.operatorframework.io.index.database.v1=/database/index.db
ADD index.db /database/index.db
EXPOSE 50051
ENTRYPOINT ["/bin/opm"]
CMD ["registry", "serve", "--database", "/database/index.db"]