FROM registry.cn-shanghai.aliyuncs.com/c7n/javabase:0.9.0
WORKDIR /choerodon
COPY app.jar manager-service.jar
COPY dist dist
RUN chmod +x /choerodon/dist/env.sh \
    && chown -R www-data:www-data /choerodon
USER www-data
CMD /choerodon/dist/env.sh java $JAVA_OPTS $SKYWALKING_OPTS -jar /choerodon/manager-service.jar