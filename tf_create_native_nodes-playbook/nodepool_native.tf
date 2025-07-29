##注解部分为主要配置
resource "tencentcloud_kubernetes_native_node_pool" "kubernetes_native_node_pool" {
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
    security_group_ids       = ["sg-ephmfdsf"]    ##安全组id
    subnet_ids               = ["subnet-mw0fqo4"]    ##子网id
    auto_repair              = true  #是否开启自愈，需要设置自愈策略
    health_check_policy_name = null  #自愈策略id，自愈策略需要在控制台事先创建好

    enable_autoscaling       = false      #是否开启自动伸缩，false为关闭
    host_name_pattern        = null
    replicas=1                #初始节点池期望节点数
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
