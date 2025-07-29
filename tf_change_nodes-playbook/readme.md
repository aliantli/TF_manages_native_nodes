
# 背景：
客户之前使用terraform增删普通节点，没有节点池概念，也没用过节点池，切换原生节点需要使用terraform更新节点池资源数来增删节点。
# 测试场景：
1.使用tf创建原生节点池，关闭自动弹缩，并设置期望个数1<br>
2.基于创建的节点池，调整期望个数为3，查看是否扩容3个节点<br>
3.基于创建的节点池，调整期望个数为0，查看是否缩容到没有节点<br>
# 准备阶段
创建好原生节点<br>
详情可参考:[tf_create_native_nodes-playbook](https://github.com/aliantli/TF_manages_native_nodes/tree/95a38fcc6a3a51e6503600ab0a52b0903382a5cf/tf_create_native_nodes-playbook)


# 快速开始
## 扩容
### 更改期望
```
[root@VM-35-179-tlinux  terraform]#  sed -i 's/replicas=1/replicas=3/g' nodepool_native.tf
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
前往 控制台-->集群-->节点管理进行查看
[<img width="838" height="483" alt="企业微信截图_dbe2b0ec-4144-49c7-bf4a-ce36bdfcb833" src="https://github.com/user-attachments/assets/d7cde067-4044-4404-aa6f-fc9de9c84496" />
](https://github.com/aliantli/TF_manages_native_nodes/blob/816a1cd2144326f794b2dfa1e384c872c0436d83/tf_change_nodes-playbook/image/Expansion.md)
## 缩容
### 更改期望
```
[root@VM-35-179-tlinux  terraform]#  sed -i 's/replicas=3/replicas=0/g' nodepool_native.tf
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
前往 控制台-->集群-->节点管理进行查看<br>
[<img width="879" height="478" alt="企业微信截图_38d25747-b4f5-4945-b2a7-8a5948729a73" src="https://github.com/user-attachments/assets/fbcbf298-91da-4779-b5c4-b6d3eb4886b5" />](https://github.com/aliantli/TF_manages_native_nodes/blob/5dd50d1fc0c573e6bae66c86e2c974bbd2144d62/tf_change_nodes-playbook/image/Expansion.md)


