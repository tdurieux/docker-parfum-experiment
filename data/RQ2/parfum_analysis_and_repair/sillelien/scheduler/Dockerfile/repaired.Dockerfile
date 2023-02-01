FROM sillelien/jessiej:0.4.127

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

COPY update.sh /etc/services.d/update/run
RUN chmod a+x /etc/services.d/update/run
COPY server/target/tutum-scheduler-1.0-SNAPSHOT.jar /app/scheduler.jar
CMD java -jar /app/scheduler.jar
