#!/bin/bash

#To discover API server address run: kubectl config view --minify | grep server

/opt/spark/bin/spark-shell --master k8s://https://kubernetes.default.svc.cluster.local:443 \
--deploy-mode cluster \
--conf spark.driver.host=busybox.spark.svc.cluster.local \
--conf spark.driver.port=27413 \
--conf spark.kubernetes.namespace=spark \
--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark-sa \
--conf spark.kubernetes.container.image=mesosphere/spark:2.4.3-bin-hadoop2.9-k8s


/opt/spark/bin/spark-submit --master k8s://https://kubernetes.default.svc.cluster.local:443 \
--deploy-mode cluster \
--conf spark.kubernetes.namespace=spark \
--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark-sa \
--conf spark.kubernetes.container.image=mesosphere/spark:2.4.3-bin-hadoop2.9-k8s  \
--class org.apache.spark.examples.SparkPi \
local:///opt/spark/examples/jars/spark-examples_2.11-2.4.0.jar 1000
