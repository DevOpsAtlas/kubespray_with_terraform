# Kubespray with terraform

本仓库包括[30分钟快速搭建生产级k8s集群](https://youtu.be/rCfdAXbpP5I)视频中出现的的源代码，详细演示过程请查看视频内容

[![Watch the video](https://img.youtube.com/vi/rCfdAXbpP5I/0.jpg)](https://youtu.be/rCfdAXbpP5I)

### 如何使用

#### terraform

下方文档说明均以linode平台为例，gcp类似

1. 克隆本项目到本地 `git clone https://github.com/DevOpsAtlas/kubespray_with_terraform.git`
2. 初始化submodule `git submodule update --init --recursive`
3. 获取linode的[API Token](https://techdocs.akamai.com/linode-api/reference/get-started#personal-access-tokens)
4. 进入terraform/linode目录，新建`terraform.tfvars`配置/修改相关变量。至少需要配置api_token和root_pass两个变量，同时需要确保SSH公钥和SSH密钥路径存在
```hcl
# 示例 terraform.tfvars
api_token = "xxxx"
root_pass = "xxxx"
```
5. 复制`kubespray/inventory/sample`目录，在项目根目录执行`cp -rfp kubespray/inventory/sample kubespray/inventory/atlas`
6. 回到`terraform/linode`目录，依次执行`terraform init` `terraform fmt` `terraform validate` `terraform plan` 命令
7. 检查无误后，执行`terraform apply`

#### Kubespray

进入kubespray目录，创建python虚拟环境，然后配置对应变量，最后执行即可。具体步骤请查看[官方文档](https://github.com/kubernetes-sigs/kubespray/blob/master/docs/getting_started/setting-up-your-first-cluster.md#set-up-kubespray)

