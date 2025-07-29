# 背景
客户普通节点是用tf管理的，由于项目迁移紧急没时间验证原生节点的tf管理，需要验证下 tf 购买原生节点
# 操作
## tf debug
运行过程中如果有tf报错，可以开启tf debug查看具体报错信息，开启方法是设置环境变量，之后可以在terraform.log具体查看debug日志
```
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform.log
```
# 注意事项
注意terraform里原生节点池文档里有一些字段是forenew属性，比如计费字段charge_type，tf文件里该字段修改会导致整个节点池删除重建。创建节点池的时候把这些forcenew字段确认好，之后执行terraform apply的tf文件不要改动这些字段

# 准备
已有tke集群
本操作验证是在已有集群里创建原生节点池
测试集群id：cls-mhpmyfrs
tf原生节点字段说明：[Terraform Registry](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_native_node_pool)
# 创建目录并准备nodepool_native.tf文件以及provider.tf文件

### provider.tf
```
terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      # 通过version指定版本
      version = ">=1.81.133"  #">="为指定版本 “～>"为指定最低版本
    }
  }
}

provider "tencentcloud" {
  secret_id = "SECRET_ID"    
  secret_key = "SECRET_KEY"    #换成自己的SECRET_ID和SECRET_KEY
  region     = "ap-guangzhou"    #指定地域

}
```
### nodepool_native.tf
```
##注解部分为主要配置
resource "tencentcloud_kubernetes_native_node_pool" "native_nodepool_cvm" {
  name                = "native"
  cluster_id          = "cls-mhpmyfrs"   ##集群id
  type                = "Native"        ##节点类型
  unschedulable       = false            ##是否封锁节点，true为封锁
  deletion_protection = true              ##删除保护​​
  labels {
    name  = "test11"
    value = "test21"
  }
 taints {                      #污点
    key    = "product"
    value  = "true"
    effect = "NoSchedule"    #污点效果：NoSchedule：禁止调度新 Pod、PreferNoSchedule：尽量避免调度、NoExecute：驱逐现有 Pod
  }
tags {                         #标签
    resource_type = "machine"  #指定资源类型此处为 "machine"，表示该标签应用于​计算资源
    tags {                     #定义具体的标签键值对
      key   = "managedBy"
      value = "terraform"
    }
  }

  native {
    scaling {
      min_replicas  = 1    #最小副本数（下限保护）
      max_replicas  = 10    #最大副本数（上限保护）
      create_policy = "ZoneEquality"  #扩缩容策略：ZoneEquality:多可用区均匀分布(默认)、Priority:优先选择指定可用区
    }
    instance_charge_type     = "POSTPAID_BY_HOUR"    ##按量计费，其他计费模式可能会导致创建节点时卡在第一步
    instance_types           = ["SA2.MEDIUM2"]    ##机器类型
    security_group_ids       = [tencentcloud_security_group.baseline_sg.id]    ##安全组id
    subnet_ids               = ["<sub-id>"]    ##子网id
    auto_repair              = true  #是否开启自愈，需要设置自愈策略
    health_check_policy_name = null  #自愈策略id，自愈策略需要在控制台事先创建好

    enable_autoscaling       = false      #是否开启自动伸缩，false为关闭
    host_name_pattern        = null
    replicas                 = 1                #初始节点池期望节点数
    machine_type             = "Native"     #节点类型

    system_disk {                    #定义节点的操作系统磁盘类型和容量
      disk_type = "CLOUD_PREMIUM"    #云盘类型:CLOUD_PREMIUM：高性能云盘、CLOUD_SSD：SSD 云盘、CLOUD_BASIC：普通云盘
      disk_size = 50    #磁盘大小（GB）范围：Linux：50-500,Windows：50-500
    }
management {
      nameservers = ["183.60.83.19", "183.60.82.98"]    #自定义 DNS 服务器列表
      kernel_args = ["kernel.pid_max=65535", "fs.file-max=400000"]  #Linux 内核参数调整（需符合 sysctl 格式）
    }

kubelet_args      = ["allowed-unsafe-sysctls=net.core.somaxconn"]  #传递给 kubelet 的启动参数需符合 Kubernetes 规范
    lifecycle {
      pre_init  = "ZWNobyBoZWxsb3dvcmxk"  #节点初始化前执行的脚本（Base64 编码）
      post_init = "ZWNobyBoZWxsb3dvcmxk"  #节点初始化后执行的脚本（Base64 编码）
    }
runtime_root_dir   = "/var/lib/containerd"

    data_disks {      
        auto_format_and_mount = true
        disk_type             = "CLOUD_PREMIUM"    #数据盘类型：CLOUD_PREMIUM:高性能云盘、CLOUD_SSD:SSD 云盘
        disk_size             = 50  #磁盘大小（GB），范围：
        file_system           = "xfs"
        mount_target          = "/var/lib/container"  #挂载目标路径（需为绝对路径）
    }

    
  }
}

```
# 初始化工作目录
```
#到工作目录执行   
[root@VM-35-179-tlinux ~]# terraform init
#如果provider.tf里的版本比较高，可以使用如下命令。正常provider.tf里如果没有设置version，会根据terraform下载的当时版本来初始化
[root@VM-35-179-tlinux ~]# terraform init -upgrade
```
# 创建原生节点
```
[root@VM-35-179-tlinux ~]# terraform apply
```
    


