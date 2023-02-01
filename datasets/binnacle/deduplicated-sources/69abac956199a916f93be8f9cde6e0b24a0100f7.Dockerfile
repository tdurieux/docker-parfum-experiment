FROM clojure

COPY target/cmr-bootstrap-app-0.1.0-SNAPSHOT-standalone.jar /app/
EXPOSE 3006

WORKDIR /app

CMD "java" "-classpath" "/app/cmr-bootstrap-app-0.1.0-SNAPSHOT-standalone.jar" "clojure.main" "-m" "cmr.bootstrap.runner"
