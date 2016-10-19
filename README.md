### Running Wildfly Standalone HA with Apache Modcluster

#### Apache Modcluster

Docker Image for Apache Modcluster can be found in the following repo:
>karm/mod_cluster-master-dockerhub/

#### Start the Apache httpd + modcluster.

> docker run --rm -it --name modcluster -e MODCLUSTER_NET="192.168. 172. 10." -e MODCLUSTER_PORT=80 -p 80:80 -p 23364:23364 karm/mod_cluster-master-dockerhub

##### Check modcluster is running
> http://192.168.99.100/mcm

#### Dockerfile and Resources

Dockerfile and resources used to run the Jboss image can be found in the following location:

> https://github.com/SleepingTalent/wildfly-standalone-ha-docker

#### Run Wildfly in standalone
>docker run --rm -it -h wildfly-1 --name wildfly-1 -e MODCLUSTER_HOST=192.168.99.100 sleepingtalent/wildfly-standalone-ha:1.0.1
