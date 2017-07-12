#!/bin/bash
ETCD_NODE_0=etcd-node-0
ETCD_NODE_1=etcd-node-1
ETCD_NODE_2=etcd-node-2

for name in $ETCD_NODE_0 $ETCD_NODE_1 $ETCD_NODE_2
do
  docker-machine create -d virtualbox $name

  eval $(docker-machine env $name)
  docker run \
    -d \
    -p 2379:2379 \
    -p 2380:2380 \
    --name etcd \
    --restart=always \
    --net=host \
    registry.cn-shenzhen.aliyuncs.com/donjote/etcd  \
    /usr/local/bin/etcd \
    --name $name \
    --initial-advertise-peer-urls http://$(docker-machine ip $name):2380 \
    --listen-peer-urls http://$(docker-machine ip $name):2380 \
    --listen-client-urls http://$(docker-machine ip $name):2379 \
    --advertise-client-urls http://$(docker-machine ip $name):2379 \
    --initial-cluster $ETCD_NODE_0=http://$(docker-machine ip $ETCD_NODE_0):2380,$ETCD_NODE_1=http://$(docker-machine ip $ETCD_NODE_1):2380,$ETCD_NODE_2=http://$(docker-machine ip $ETCD_NODE_2):2380 \
    --initial-cluster-state new \
    --initial-cluster-token etcd-cluster
done
