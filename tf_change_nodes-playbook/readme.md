
# 背景：
客户之前使用terraform增删普通节点，没有节点池概念，也没用过节点池，切换原生节点需要使用terraform更新节点池资源数来增删节点。
# 测试场景：
1.使用tf创建原生节点池，关闭自动弹缩，并设置期望个数0
2.基于创建的节点池，调整期望个数为2，查看是否扩容2个节点
3.基于创建的节点池，调整期望个数为0，查看是否缩容到没有节点
# 准备阶段
创建原生节点
```
[root@VM-35-179-tlinux ~]# terraform apply    
```

```
[root@VM-35-179-tlinux ~]# terraform apply    #出现以下为成功特别注意返回的“ 1 changed, ”
  Enter a value: yes

tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Modifying... [id=cls-mhpmyfrs#np-fgh585yk]
tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Modifications complete after 0s [id=cls-mhpmyfrs#np-fgh585yk]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```
