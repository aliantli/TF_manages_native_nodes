# 准备阶段
1.创建好原生节点<br>
详情可参考:[tf_create_native_nodes-playbook](https://github.com/aliantli/TF_manages_native_nodes/tree/95a38fcc6a3a51e6503600ab0a52b0903382a5cf/tf_create_native_nodes-playbook)
2.执行下列命令模拟误删tfstate文件
```
[root@VM-35-48-tlinux terraform]# rm terraform.tfstate*
```
# 快速开始
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

