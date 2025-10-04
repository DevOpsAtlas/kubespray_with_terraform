# Kubespray with terraform

本仓库包括[30分钟快速搭建生产级k8s集群](https://youtu.be/rCfdAXbpP5I)视频中出现的的源代码，详细演示过程请查看视频内容

[![Watch the video](https://img.youtube.com/vi/rCfdAXbpP5I/0.jpg)](https://youtu.be/rCfdAXbpP5I)

### 如何使用

#### terraform

首先你需要有一个Google Cloud Platform或者linode的账户凭据，然后进入terraform/gce或terraform/linode文件夹，配置相关变量，执行`terraform apply`即可。
默认gce会申请7台实例，linode则是6台，均可以按需修改

#### Kubespray

进入kubespray目录，创建python虚拟环境，然后配置对应变量，最后执行即可。具体请查看[官方文档](https://github.com/kubernetes-sigs/kubespray/blob/master/docs/getting_started/setting-up-your-first-cluster.md#set-up-kubespray)

