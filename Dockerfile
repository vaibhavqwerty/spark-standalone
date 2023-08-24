FROM openjdk:8-jdk

ENV spark_ver 3.0.2

# # Get Spark from US Apache mirror.

# RUN apt-get update && apt-get install -y curl vim wget python3 python3-pip python3-pandas

# RUN update-alternatives --install "/usr/bin/python" "python" "$(which python3)" 1

# # Fix the value of PYTHONHASHSEED
# # Note: this is needed when you use Python 3.3 or greater
# ENV PYTHONHASHSEED=1

RUN mkdir -p /opt && \
    cd /opt && \
    curl https://archive.apache.org/dist/spark/spark-3.0.2/spark-3.0.2-bin-hadoop3.2.tgz | \
        tar -zx && \
    ln -s spark-3.0.2-bin-hadoop3.2 spark && \
    echo Spark ${spark_ver} installed in /opt

ENV PATH $PATH:/opt/spark/bin

RUN mkdir /opt/spark/docker-configs

RUN mkdir opt/spark/hive-warehouse

COPY ./jars/postgresql-42.5.0.jar /opt/spark/jars/postgresql-42.5.0.jar

# RUN echo "#!/bin/bash" >> /opt/spark/docker-configs/common.sh
# RUN echo "unset SPARK_MASTER_PORT" >> /opt/spark/docker-configs/common.sh

COPY ./spark-files/common.sh /opt/spark/docker-configs/common.sh

# RUN echo "#!/bin/bash" >> /opt/spark/docker-configs/spark-master
# RUN echo ". /opt/spark/docker-configs/common.sh" >> /opt/spark/docker-configs/spark-master
# RUN echo 'echo "$(hostname -i) spark-master" >> /etc/hosts' >> /opt/spark/docker-configs/spark-master
# RUN echo "/opt/spark/bin/spark-class org.apache.spark.deploy.master.Master --ip spark-master --port 7077 --webui-port 8080" >> /opt/spark/docker-configs/spark-master

COPY ./spark-files/spark-master /opt/spark/docker-configs/spark-master

# RUN echo "#!/bin/bash" >> /opt/spark/docker-configs/spark-thrift
# RUN echo ". /opt/spark/sbin/start-thriftserver.sh" >> /opt/spark/docker-configs/spark-thrift

COPY ./spark-files/spark-thrift /opt/spark/docker-configs/spark-thrift

# RUN echo "spark.master spark://spark-master:7077" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hive.server2.transport.mode http" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hive.server2.thrift.http.port 10001" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hive.server2.http.endpoint cliservice" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.sql.warehouse.dir opt/spark/hive-warehouse" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.sql.catalogImplementation hive" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.sql.hive.metastore.sharedPrefixes org.postgresql" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.hive.metastore.warehouse.dir opt/spark/hive-warehouse" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.hive.metastore.schema.verification false" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.hive.metastore.schema.verification.record.version false" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.javax.jdo.option.ConnectionURL jdbc:postgresql://pg-minikube-postgresql:5432/hive?useSSL=false" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.javax.jdo.option.ConnectionPassword postgres" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.javax.jdo.option.ConnectionUserName postgres" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.javax.jdo.option.ConnectionDriverName org.postgresql.Driver" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.datanucleus.schema.autoCreateAll true" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.datanucleus.fixedDatastore false" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.fs.s3a.access.key AKIA3FEFCFQTVDRHRTYD" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.fs.s3a.secret.key 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" >> /opt/spark/conf/spark-defaults.conf
# RUN echo "spark.hadoop.fs.s3a.impl org.apache.hadoop.fs.s3a.S3AFileSystem" >> /opt/spark/conf/spark-defaults.conf



# RUN echo "#!/bin/bash" >> /opt/spark/docker-configs/spark-worker

# RUN echo ". /opt/spark/docker-configs/common.sh" >> /opt/spark/docker-configs/spark-worker

# RUN echo "if ! getent hosts spark-master; then "  >> /opt/spark/docker-configs/spark-worker
# RUN echo "sleep 5 "  >> /opt/spark/docker-configs/spark-worker
# RUN echo "exit 0 " >> /opt/spark/docker-configs/spark-worker
# RUN echo "fi" >> /opt/spark/docker-configs/spark-worker
# RUN echo "/opt/spark/bin/spark-class org.apache.spark.deploy.worker.Worker spark://spark-master:7077 --memory 2g  --cores 2 --webui-port 8081" >> /opt/spark/docker-configs/spark-worker

COPY ./spark-files/spark-worker /opt/spark/docker-configs/spark-worker

RUN chmod +x /opt/spark/docker-configs/spark-master /opt/spark/docker-configs/spark-thrift /opt/spark/docker-configs/spark-worker /opt/spark/docker-configs/common.sh 

RUN more /opt/spark/docker-configs/spark-worker
