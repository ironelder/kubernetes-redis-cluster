# kubernetes-redis-cluster
###전제조건
```
kubernetes clustering 의 구성이 완료된 상태에서 진행한다.
kubectl이 설치된 상태에서 진행한다.
Redis Clustering Port는 7000번과 17000을 사용할 것 이다.
Redis Clustering은 Master 3개로 구성한다.
```

###kubernetes 설치시 Cluster Range 조건
```
- 192.168.0.0/16
```

###kubernetes 구성 요건
```
- Master 1개
- Slave 3개 이상
```

###kubernetes, kubectl version
```
Client Version: GitVersion:"v1.3.3"
Server Version: GitVersion:"v1.3.3"
```

###Create Redis Services
```
kubectl create -f services
```
또는
```
kubectl create -f services/redis-1.yaml
kubectl create -f services/redis-2.yaml
kubectl create -f services/redis-3.yaml
```

###Create Redis Nodes
```
kubectl create -f replications
```
또는
```
kubectl create -f replications/redis-1.yaml
kubectl create -f replications/redis-2.yaml
kubectl create -f replications/redis-3.yaml
```

###Connect Nodes
```
kubectl run -i --tty ubuntu \
  --image=ubuntu \
  --restart=Never /bin/bash
```
Waiting for pod default/ubuntu-239113138-0qxec to be running, status is Pending, pod ready: false
위와 같은 메시지가 출력되는데 이미지가 없어서 그렇다.
신경쓰지 않아도 된다.
만약 보기 싫다면 --quiet 또는 --silent 옵션을 붙여준다.

```
apt-get update
apt-get install ruby vim wget redis-tools
wget http://download.redis.io/redis-stable/src/redis-trib.rb
chmod +x redis-trib.rb
gem install redis
```

```
./redis-trib.rb create --replicas 0 \
  192.168.0.111:7000 \
  192.168.0.111:7000 \
  192.168.0.111:7000
```
