terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      # 通过version指定版本
      version = ">=1.81.133"  #">="为指定版本 “～>"匹配指定版本及兼容的次版本/修订版本​
    }
  }
}

provider "tencentcloud" {
  secret_id = "SECRET_ID"    
  secret_key = "SECRET_KEY"    #换成自己的SECRET_ID和SECRET_KEY
  region     = "ap-guangzhou"    #指定地域

}
