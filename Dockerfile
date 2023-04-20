FROM ubuntu:22.04

# disables optional dependencies from being installed
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# temporarily sets DEBIAN_FRONTEND to noninteractive
# prevents errors from unnecessary prompts in non-interactive build stage
RUN DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y python3 \
  && apt-get install -y curl \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

ENV SCALA_VERSION=2.13
ENV KAFKA_VERSION=3.4.0
ENV FILE_VERSION=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
#ENV FILE_VERSION=${SCALA_VERSION}-${KAFKA_VERSION}
ENV KAFKA_HOME=/opt/kafka

RUN mkdir ${KAFKA_HOME}
RUN wget --no-check-certificate https://downloads.apache.org/kafka/3.4.0/${FILE_VERSION}.tgz
RUN tar -xf ${FILE_VERSION}.tgz
RUN cp -r ${FILE_VERSION}/ ${KAFKA_HOME}

# Remove leftover binaries
RUN rm ${FILE_VERSION}.tgz

# Copy start-up script into kafka directory
COPY start-kafka.sh ${KAFKA_HOME}

# create non-root user
RUN useradd -ms /bin/bash kafkauser

# Update file permissions to enable execution
RUN chown -R kafkauser:kafkauser ${KAFKA_HOME}
#RUN chmod 777 ${KAFKA_HOME}

# Set working directory
WORKDIR ${KAFKA_HOME}

USER kafkauser

ENTRYPOINT ["/bin/bash", "./start-kafka.sh"]

#https://downloads.apache.org/kafka/3.4.0/kafka_2.13-3.4.0.tgz