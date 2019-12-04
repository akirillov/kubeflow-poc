FROM akirillov/spark:spark-2.4.3-hadoop-2.9-k8s-horovod

ARG NB_USER=jovyan
USER root

ENV DEBIAN_FRONTEND noninteractive

ENV NB_USER $NB_USER

ENV NB_UID 1000
ENV HOME /home/$NB_USER
ENV NB_PREFIX /

# Use bash instead of sh
SHELL ["/bin/bash", "-c"]
# Create NB_USER user with UID=1000 and in the 'users' group
# but allow for non-initial launches of the notebook to have
# $HOME provided by the contents of a PV
RUN useradd -M -s /bin/bash -N -u $NB_UID $NB_USER && \
    chown -R ${NB_USER}:users /usr/local/bin && \
    mkdir -p $HOME


RUN pip3 install --upgrade pip \
    && pip3 install --upgrade \
    jupyterlab \
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

# Configure container startup
EXPOSE 8888
USER jovyan
ENTRYPOINT ["tini", "--"]
CMD ["sh","-c", "jupyter notebook --notebook-dir=/home/${NB_USER} --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]
