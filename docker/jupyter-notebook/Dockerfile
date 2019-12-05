FROM akirillov/spark:spark-2.4.3-hadoop-2.9-k8s-horovod

ENV NB_PREFIX /

USER root

RUN pip3 install --upgrade pip \
    && pip3 install --upgrade \
    jupyterlab \
    matplotlib \
    plotly \
    py4j \
    toree \
    && jupyter toree install --spark_home=${SPARK_HOME} --toree_opts='--nosparkcontext' \
    && chown -R ${SPARK_USER}:users ${HOME}


ENV PYTHONPATH=${SPARK_HOME}/python:$PYTHONPATH \
    PYSPARK_DRIVER_PYTHON="jupyter" \
    PYSPARK_DRIVER_PYTHON_OPTS="notebook" \
    PYSPARK_PYTHON=python3

# Configure container startup
EXPOSE 8888
USER $SPARK_USER
ENTRYPOINT ["tini", "--"]
CMD ["sh","-c", "jupyter notebook --user=${SPARK_USER} --notebook-dir=/home/${SPARK_USER} --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]
