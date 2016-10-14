# wildfly-standalone-ha-docker
wildfly-standalone-ha-docker

#######Apache Modcluster###########

https://hub.docker.com/r/karm/mod_cluster-master-dockerhub/

Start the Apache httpd + modcluster.

-e MODCLUSTER_MANAGER_NET=127.0.0.1 

docker run --rm -it --name modcluster -e MODCLUSTER_MANAGER_NET=192.168.99.100 -e MODCLUSTER_NET="192.168. 172. 10." -e MODCLUSTER_PORT=80 -p 80:80 karm/mod_cluster-master-dockerhub

docker run --rm -it --name modcluster -e MODCLUSTER_NET="192.168. 172. 10." -e MODCLUSTER_PORT=80 -p 80:80 karm/mod_cluster-master-dockerhub

http://192.168.99.100/mcm


####################################


docker run --rm -it --name wildfly-1 wildfly-standalone-ha

docker run --rm -it --name wildfly-1 -p 8080:8080 -p 9990:9990 -p 8009:8009 -e MODCLUSTER_HOST=192.168.99.100 wildfly-standalone-ha