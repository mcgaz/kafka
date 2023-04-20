#!/bin/bash

# remove all comments from zookeeper.properties and print to console for the record##
sed -i '/^#.*$/d' /opt/kafka/config/zookeeper-properties
echo "Starting zookeeper using configuration file"
echo "-------------------------------------------"
cat /opt/kafka/config/zookeeper.properties
echo "-------------------------------------------"

# Start zookeeper in the background, and wait for it to settle
/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties &
sleep 10s

# Remove all comments from server.properties and print to console for the record
sed -i '/^#.*$/d' /opt/kafka/config/server-properties
echo "Starting kafka using configuration file"
echo "-------------------------------------------"
cat /opt/kafka/config/server.properties
echo "-------------------------------------------"

# Start kafka in the foreground
/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties