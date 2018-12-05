FROM confluentinc/cp-schema-registry:5.0.1

RUN mkdir /etc/kafka
COPY schema_server_jaas.conf /etc/kafka

ENV KAFKA_OPTS='-Djava.security.auth.login.config=/etc/kafka/schema_server_jaas.conf'