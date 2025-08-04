# 背景
在生产环境中，如果terraform state被删除(或者terraform.tfstate)删除，则不会保留记录，本文针对该种情况演示通过命令来导入对应的资源以达到恢复被删除的文件
# 准备阶段
1.创建好原生节点，具体操作可参考:[tf_create_native_nodes-playbook](./../tf_create_native_nodes-playbook)<br>

2.执行下列命令模拟误删tfstate文件
```
[root@VM-35-48-tlinux terraform]# rm terraform.tfstate*
```
# 快速开始
### 查看当前目录
```
[root@VM-35-48-tlinux terraform]# ll
total 16
-rw-r--r-- 1 root root 3357 Jul 29 17:00 nodepool_native.tf
-rw-r--r-- 1 root root  207 Jul 29 10:22 provider.tf
```
### 导入恢复
  ```
[root@VM-35-48-tlinux terraform]# terraform import tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool cls-mhpmyfrs#np-fgh585yk  #出现“Import successful!”为导入成功

tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Importing from ID "cls-mhpmyfrs#f"...
tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Import prepared!
  Prepared tencentcloud_kubernetes_native_node_pool for import
tencentcloud_kubernetes_native_node_pool.kubernetes_native_node_pool: Refreshing state... [id=cls-mhpmyfrs#f]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```
# 验证
```[root@VM-35-48-tlinux terraform]# ll
total 16
-rw-r--r-- 1 root root 3357 Jul 29 17:00 nodepool_native.tf
-rw-r--r-- 1 root root  207 Jul 29 10:22 provider.tf
-rw-r--r-- 1 root root 4344 Jul 29 17:03 terraform.tfstate
```


