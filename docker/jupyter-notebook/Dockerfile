FROM gcr.io/kubeflow-images-public/tensorflow-2.0.0a0-notebook-cpu:v0.7.0

USER root

ENV SPARK_HOME=/opt/spark
ARG SPARK_DIST=/dist
ARG SPARK_DIST_NAME="spark-2.4.3-hadoop-2.9-k8s"
ARG SPARK_DIST_URL="https://downloads.mesosphere.io/spark/assets/${SPARK_DIST_NAME}.tgz"

ARG JAVA_VERSION="8u212b03"
ENV JAVA_HOME /usr/lib/jvm/${JAVA_VERSION}
ARG JRE_DOWNLOAD_URL="https://downloads.mesosphere.com/java/openjdk-jre-${JAVA_VERSION}-hotspot-linux-x64.tar.gz"

ENV PATH=$PATH:${SPARK_HOME}/bin:${JAVA_HOME}/bin

RUN mkdir -p ${JAVA_HOME} \
    && curl -L ${JRE_DOWNLOAD_URL} | tar -C ${JAVA_HOME} --strip-components=1 -zx

RUN mkdir -p ${SPARK_DIST} ${SPARK_HOME} && \
    cd ${SPARK_DIST} && \
    wget ${SPARK_DIST_URL} && wget ${SPARK_DIST_URL}.sha512 && \
    gpg --print-md sha512 ${SPARK_DIST_NAME}.tgz | diff - ${SPARK_DIST_NAME}.tgz.sha512 && \
    tar xf ${SPARK_DIST_NAME}.tgz -C ${SPARK_DIST} --strip-components=1 && \
    mv bin conf data examples jars sbin python ${SPARK_HOME} && \
    mv kubernetes/dockerfiles/spark/entrypoint.sh /opt && \
    mv kubernetes/tests ${SPARK_HOME} && \
    rm -rf ${SPARK_DIST}

# https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/issues/591
RUN rm ${SPARK_HOME}/jars/kubernetes-client-4.1.2.jar
ADD https://repo1.maven.org/maven2/io/fabric8/kubernetes-client/4.4.2/kubernetes-client-4.4.2.jar ${SPARK_HOME}/jars
ADD log4j.properties ${SPARK_HOME}/conf

# Install Open MPI
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      cmake \
      g++-4.8 \
    && mkdir /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-4.0.0.tar.gz && \
    tar zxf openmpi-4.0.0.tar.gz && \
    cd openmpi-4.0.0 && \
    ./configure --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi

RUN pip3 install --upgrade pip \
    && pip3 install --upgrade \
    horovod \
    matplotlib \
    plotly \
    py4j \
    toree \
    && jupyter toree install --spark_home=${SPARK_HOME} --toree_opts='--nosparkcontext' \
    && chown -R ${NB_USER}:users ${SPARK_HOME} /opt/entrypoint.sh

ENV PYTHONPATH=${SPARK_HOME}/python:$PYTHONPATH \
    PYSPARK_DRIVER_PYTHON="jupyter" \
    PYSPARK_DRIVER_PYTHON_OPTS="notebook" \
    PYSPARK_PYTHON=python3

USER jovyan
