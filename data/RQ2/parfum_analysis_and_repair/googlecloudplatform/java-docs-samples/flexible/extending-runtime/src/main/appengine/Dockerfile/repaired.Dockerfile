FROM gcr.io/google_appengine/jetty9

RUN apt-get update && apt-get install --no-install-recommends -y fortunes && rm -rf /var/lib/apt/lists/*;
ADD extendingruntime-1.0-SNAPSHOT.war $JETTY_BASE/webapps/root.war
