# 背景
客户普通节点是用tf管理的，由于项目迁移紧急没时间验证原生节点的tf管理，需要验证下 tf 购买原生节点
# 注意事项
1.运行过程中如果有tf报错，可以开启tf debug查看具体报错信息，开启方法是设置环境变量，之后可以在terraform.log具体查看debug日志
```
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform.log
```

2.注意terraform里原生节点池文档里有一些字段是forenew属性，比如计费字段charge_type，tf文件里该字段修改会导致整个节点池删除重建。创建节点池的时候把这些forcenew字段确认好，之后执行terraform apply的tf文件不要改动这些字段

# 准备
1.已有tke集群本操作验证是在已有集群里创建原生节点池<br>
2.测试集群id：cls-mhpmyfrs<br>
3.在工作目录创建好nodepool_native.tf和provider.tf文件<br>
4.tf原生节点字段说明：[Terraform Registry](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_native_node_pool)
# 快速开始
### 初始化工作目录
```
#到工作目录执行   
[root@VM-35-179-tlinux ~]# terraform init
#如果provider.tf里的版本比较高，可以使用如下命令。正常provider.tf里如果没有设置version，会根据terraform下载的当时版本来初始化
[root@VM-35-179-tlinux ~]# terraform init -upgrade
```
### 创建原生节点
```
[root@VM-35-179-tlinux ~]# terraform apply        #出现下面内容即为成功
tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Creation complete after 1s [id=cls-mhpmyfrs#np-b34998q6]
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
### 验证
前往控制台->节点管理查看
[<img width="496" height="282" alt="Clipboard_Screenshot_1753772892" src="https://github.com/user-attachments/assets/4195e6dc-62e9-4632-8e80-7dba01917b8a" />
](https://github.com/aliantli/TF_manages_native_nodes/blob/e7efe972fc8fae65cea2909cc04bac197e08acd2/tf_create_native_nodes-playbook/image/verify.md)
# 节点池资源清理  
```
[root@VM-35-179-tlinux ~]# terraform destroy #出现以下内容为删除成功
  Enter a value: yes

tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Destroying... [id=cls-mhpmyfrs#np-b34998q6]
tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.
```


