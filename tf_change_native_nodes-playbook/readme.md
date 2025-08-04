
# 背景
客户之前使用terraform增删普通节点，没有节点池概念，也没用过节点池，切换原生节点需要使用terraform更新节点池资源数来增删节点。
# 测试场景
1.使用tf创建原生节点池，关闭自动弹缩，并设置期望个数1<br>
2.基于创建的节点池，调整期望个数为3，查看是否扩容3个节点<br>
3.基于创建的节点池，调整期望个数为0，查看是否缩容到没有节点<br>
# 准备阶段
创建好原生节点<br>
详情可参考:[tf_create_native_nodes-playbook](./../tf_create_native_nodes-playbook)


# 快速开始
## 扩容
### 更改期望
```
[root@VM-35-179-tlinux  terraform]#  sed -i 's/replicas=1/replicas=3/g' nodepool_native.tf    #replicas=1原始期望、replicas=3更改后的期望
```
### 更新节点池
```
[root@VM-35-179-tlinux  terraform]# terraform apply    #出现以下为成功特别注意返回的“ 1 changed, ”
  Enter a value: yes

tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Modifying... [id=cls-mhpmyfrs#np-fgh585yk]
tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Modifications complete after 0s [id=cls-mhpmyfrs#np-fgh585yk]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```
### 验证
```
#显示改节点池内有三个节点
[root@VM-35-48-tlinux terraform]# kubectl get nodes -l test11=test21 --no-headers | wc -l    #test11=test21为创建节点是的labels标签
3
```
## 缩容
### 更改期望
```
[root@VM-35-179-tlinux  terraform]#  sed -i 's/replicas=3/replicas=0/g' nodepool_native.tf    #replicas=3原始期望、replicas=0更改后的期望
```

### 更新节点池
```
[root@VM-35-179-tlinux  terraform]# terraform apply    #出现以下为成功特别注意返回的“ 1 changed, ”
  Enter a value: yes

tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Modifying... [id=cls-mhpmyfrs#np-fgh585yk]
tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Modifications complete after 0s [id=cls-mhpmyfrs#np-fgh585yk]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```
### 验证
```
#显示该节点池内节点数量为零
[root@VM-35-48-tlinux ~]# kubectl get nodes -l test11=test21 --no-headers | wc -l      
0
```

