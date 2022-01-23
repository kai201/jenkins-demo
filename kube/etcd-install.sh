!/usr/bin/env bash

etcdbin=http://aliacs-k8s-cn-hangzhou.oss.aliyuncs.com/etcd/etcd-v3.4.3/etcd
etcdctlbin=http://aliacs-k8s-cn-hangzhou.oss.aliyuncs.com/etcd/etcd-v3.4.3/etcdctl

function download(){
    wget -O etcd ${etcdbin}
    wget -O etcdctl ${etcdctlbin}
    chmod +x {etcd,etcdctl}
    mv etcd /usr/bin/etcd
    mv etcdctl /usr/bin/etcdctl
    etcd --version
}

function config() {
    ETCD_FILE=/lib/systemd/system/etcd.service
    sed -i "/ETCD_EXPERIMENTAL_BACKEND_BBOLT_FREELIST_TYPE/ d" ${ETCD_FILE}
    sed -i "/ETCD_QUOTA_BACKEND_BYTES/ d" ${ETCD_FILE}
    sed -i "/^\[Service\]/a\Environment=\"ETCD_EXPERIMENTAL_BACKEND_BBOLT_FREELIST_TYPE=map\"" ${ETCD_FILE}
    sed -i "/^\[Service\]/a\Environment=\"ETCD_QUOTA_BACKEND_BYTES=100000000000\"" ${ETCD_FILE}
    sed -i "s/initial-cluster-state new/initial-cluster-state existing/g" ${ETCD_FILE}

    systemctl daemon-reload
    systemctl restart etcd
}

download; config

ENDPOINTS=`ps -eaf|grep etcd-servers|grep -v grep|awk -F "=" '{print $22}'|awk -F " " '{print $1}'`

ETCDCTL_API=3 etcdctl \
        --endpoints=${ENDPOINTS}         \
        --cacert=/var/lib/etcd/cert/ca.pem         \
        --cert=/var/lib/etcd/cert/etcd-client.pem         \
        --key=/var/lib/etcd/cert/etcd-client-key.pem \
        member list


# curl -sfL https://get.k3s.io | K3S_DATASTORE_ENDPOINT="etcd" sh -s – –docker –default-local-storage-path /home/k3s