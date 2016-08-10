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
  192.168.0.112:7000 \
  192.168.0.113:7000
```

###Add a New Node
```
kubectl get all
```
위의 명령어로 ubuntu NAME을 미리 알아둔다.

기존에 올라가있는 머신이 아닌 다른 머신을 추가해서 Node를 추가할 경우
(Port는 7000, 17000을 계속 사용한다)
```
kubectl create -f services/redis-4.yaml
kubectl create -f replications/redis-4.yaml
kubectl exec -i --tty ubuntu-239113138-rrm01 /bin/bash

./redis-trib.rb add-node 192.168.0.114:7000 \
  192.168.0.111:7000
  
./redis-trib.rb reshard 192.168.0.111:7000
.....
.....
How many slots do you want to move (from 1 to 16384)? 1000 
What is the receiving node ID? 08036dbc89a1d8c703d423c05499035072c480ab (192.168.0.114:7000 Node ID, 받을 노드의 ID)
.....
.....
Source node #1:0e028bc2e06ae5483c29ff3d757484f9470261a3 (92.168.0.111:7000 Node ID, 할당 해줄 소스 노드의 ID)
Source node #2:done   (소스 노드 ID이 끝났으면 'done'를 입력한다.)
....
....
....
Do you want to proceed with the proposed reshard plan (yes/no)? yes
.....
.....
Moving slot 999 from 192.168.0.111:7000 to 10.244.85.3:7000: 

redis-cli -h 192.168.0.111 -p 7000 cluster info
```

기존에 올라가있는 머신에 Node를 추가할 경우
(Port가 7001, 17001로 바뀐다)
```
kubectl create -f services/redis-5.yaml
kubectl create -f replications/redis-5.yaml
kubectl exec -i --tty ubuntu-239113138-rrm01 /bin/bash

./redis-trib.rb add-node 192.168.0.115:7001 \
  192.168.0.111:7000
  
./redis-trib.rb reshard 192.168.0.111:7000
.....
.....
How many slots do you want to move (from 1 to 16384)? 1000 
What is the receiving node ID? 08036dbc89a1d8c703d423c05499035072c480ab (192.168.0.115:7001 Node ID, 받을 노드의 ID)
.....
.....
Source node #1:0e028bc2e06ae5483c29ff3d757484f9470261a3 (92.168.0.111:7000 Node ID, 할당 해줄 소스 노드의 ID)
Source node #2:done   (소스 노드 ID이 끝났으면 'done'를 입력한다.)
....
....
....
Do you want to proceed with the proposed reshard plan (yes/no)? yes
.....
.....
Moving slot 999 from 192.168.0.111:7000 to 10.244.85.3:7001: 

redis-cli -h 192.168.0.111 -p 7001 cluster info
```
