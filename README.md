Kubeflow POC
---

# Jupyter integration with Spark

* run `install.sh`
* verify notebook is up
* disable Istio sidecar injection by removing a label from the namespace `k label ns spark istio-injection-`
* run example notebook and check executor pods are up and actually running tasks

Example notebook:
```
import org.apache.spark.{SparkConf, SparkContext}
import java.net._

val localIpAddress: String =  InetAddress.getLocalHost.getHostAddress

val conf = new SparkConf()
           .setAppName("Toree test")
           .setMaster("k8s://https://kubernetes.default.svc.cluster.local:443")
           .set("spark.driver.host", localIpAddress)
           .set("spark.kubernetes.namespace", "spark")
           .set("spark.kubernetes.container.image", "mesosphere/spark:2.4.3-bin-hadoop2.9-k8s")
val sc = new SparkContext(conf)
sc.parallelize(1 to 1000).sum
```
Expected output: `500500.0`

TODOs:
* pass namespace, master, and pod IP to configuration automatically (https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/#use-pod-fields-as-values-for-environment-variables)
