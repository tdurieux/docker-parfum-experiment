FROM bitnami/java:11

USER 1000

CMD ["java", "-cp", "/kubeless/lib/*:/kubeless/handler/target/handler-1.0-SNAPSHOT.jar:/kubeless/function/target/function-1.0-SNAPSHOT.jar", "io.kubeless.Handler"]