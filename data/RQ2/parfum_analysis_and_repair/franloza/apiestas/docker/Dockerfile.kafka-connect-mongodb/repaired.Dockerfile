FROM confluentinc/cp-kafka-connect:5.3.0

ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components"

RUN  confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.0.0