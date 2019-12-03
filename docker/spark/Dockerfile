FROM horovod/horovod:0.18.2-tf2.0.0-torch1.3.0-mxnet1.5.0-py3.6-cpu

ARG SPARK_HOME=/opt/spark
ARG SPARK_DIST=/dist
ENV SPARK_HOME ${SPARK_HOME}
ARG SPARK_DIST_NAME="spark-2.4.3-hadoop-2.9-k8s"
ARG SPARK_DIST_URL="https://downloads.mesosphere.io/spark/assets/${SPARK_DIST_NAME}.tgz"

ARG JAVA_VERSION="8u212b03"
ENV JAVA_HOME /usr/lib/jvm/${JAVA_VERSION}
ARG JRE_DOWNLOAD_URL="https://downloads.mesosphere.com/java/openjdk-jre-${JAVA_VERSION}-hotspot-linux-x64.tar.gz"

ENV PATH=$PATH:${SPARK_HOME}/bin:${JAVA_HOME}/bin

RUN apt-get update && apt-get install -y \
      curl \
      git \
      gpg \
      wget && \
    mkdir -p ${JAVA_HOME} \
    && curl -L ${JRE_DOWNLOAD_URL} | tar -C ${JAVA_HOME} --strip-components=1 -zx

RUN mkdir -p ${SPARK_HOME} ${SPARK_DIST} && \
    cd ${SPARK_DIST} && \
    wget ${SPARK_DIST_URL} && wget ${SPARK_DIST_URL}.sha512 && \
    gpg --print-md sha512 ${SPARK_DIST_NAME}.tgz | diff - ${SPARK_DIST_NAME}.tgz.sha512 && \
    tar xf ${SPARK_DIST_NAME}.tgz -C ${SPARK_DIST} --strip-components=1 && \
    mv jars bin sbin data python examples ${SPARK_HOME} && \
    mv kubernetes/dockerfiles/spark/entrypoint.sh /opt && \
    mv kubernetes/tests ${SPARK_HOME} && \
    rm -rf ${SPARK_DIST}

WORKDIR ${SPARK_HOME}

# https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/issues/591
RUN rm jars/kubernetes-client-4.1.2.jar
ADD https://repo1.maven.org/maven2/io/fabric8/kubernetes-client/4.4.2/kubernetes-client-4.4.2.jar jars

# Setup for the Prometheus JMX exporter.
RUN mkdir -p /etc/metrics/conf
# Add the Prometheus JMX exporter Java agent jar for exposing metrics sent to the JmxSink to Prometheus.
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.11.0/jmx_prometheus_javaagent-0.11.0.jar /prometheus/
COPY conf/metrics.properties /etc/metrics/conf
COPY conf/prometheus.yaml /etc/metrics/conf

WORKDIR ${SPARK_HOME}/work-dir

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /sbin/tini
RUN chmod +x /sbin/tini

ENTRYPOINT [ "/opt/entrypoint.sh" ]
