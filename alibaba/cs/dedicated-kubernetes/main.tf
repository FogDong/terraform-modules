module "kubernetes" {
  source = "github.com/FogDong/terraform-alicloud-kubernetes"

  new_nat_gateway       = true
  vpc_name              = var.vpc_name
  vpc_cidr              = var.vpc_cidr
  vswitch_name_prefix   = var.vswitch_name_prefix
  vswitch_cidrs         = var.vswitch_cidrs
  master_instance_types = var.master_instance_types
  worker_instance_types = var.worker_instance_types
  k8s_pod_cidr          = var.k8s_pod_cidr
  k8s_service_cidr      = var.k8s_service_cidr
  k8s_worker_number     = var.k8s_worker_number
  cpu_core_count        = var.cpu_core_count
  memory_size           = var.memory_size
  k8s_version           = var.k8s_version
  k8s_name_prefix       = var.k8s_name_prefix
}

######################
# Instance types variables
######################
variable "cpu_core_count" {
  description = "CPU core count is used to fetch instance types."
  type        = number
  default     = 4
}

variable "memory_size" {
  description = "Memory size used to fetch instance types."
  type        = number
  default     = 8
}

######################
# VPC variables
######################
variable "vpc_name" {
  description = "The vpc name used to create a new vpc when 'vpc_id' is not specified. Default to variable `example_name`"
  type        = string
  default     = "tf-k8s-vpc"
}


variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  type        = string
  default     = "10.0.0.0/8"
}

######################
# VSwitch variables
######################
variable "vswitch_name_prefix" {
  type        = string
  description = "The vswitch name prefix used to create several new vswitches. Default to variable 'example_name'."
  default     = "tf-k8s-vsw"
}

variable "number_format" {
  description = "The number format used to output."
  type        = string
  default     = "%02d"
}

variable "vswitch_ids" {
  description = "List of existing vswitch id."
  type        = list(any)
  default     = []
}

variable "vswitch_cidrs" {
  description = "List of cidr blocks used to create several new vswitches when 'vswitch_ids' is not specified."
  type        = list(any)
  default = [
    "10.1.0.0/16",
    "10.2.0.0/16",
  "10.3.0.0/16"]
}

variable "k8s_name_prefix" {
  description = "The name prefix used to create several kubernetes clusters. Default to variable `example_name`"
  type        = string
  default     = "poc"
}

variable "new_nat_gateway" {
  type        = bool
  description = "Whether to create a new nat gateway. In this template, a new nat gateway will create a nat gateway, eip and server snat entries."
  default     = true
}

variable "master_instance_types" {
  description = "The ecs instance types used to launch master nodes."
  type        = list(any)
  default = []
}

variable "worker_instance_types" {
  description = "The ecs instance types used to launch worker nodes."
  type        = list(any)
  default = []
}

variable "node_cidr_mask" {
  type        = number
  description = "The node cidr block to specific how many pods can run on single node. Valid values: [24-28]."
  default     = 24
}

variable "enable_ssh" {
  description = "Enable login to the node through SSH."
  type        = bool
  default     = true
}

variable "install_cloud_monitor" {
  description = "Install cloud monitor agent on ECS."
  type        = bool
  default     = true
}

variable "cpu_policy" {
  type        = string
  description = "kubelet cpu policy. Valid values: 'none','static'. Default to 'none'."
  default     = "none"
}

variable "proxy_mode" {
  description = "Proxy mode is option of kube-proxy. Valid values: 'ipvs','iptables'. Default to 'iptables'."
  type        = string
  default     = "iptables"
}

variable "password" {
  description = "The password of ECS instance."
  type        = string
  default     = "Just4Test"
}

variable "k8s_worker_number" {
  description = "The number of worker nodes in kubernetes cluster."
  type        = number
  default     = 2
}

# k8s_pod_cidr is only for flannel network
variable "k8s_pod_cidr" {
  description = "The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them."
  type        = string
  default     = "172.20.0.0/16"
}

variable "k8s_service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them."
  type        = string
  default     = "192.168.0.0/16"
}

variable "k8s_version" {
  description = "The version of the kubernetes version.  Valid values: '1.24.6-aliyun.1','1.22.15-aliyun.1'. Default to '1.24.6-aliyun.1'."
  type        = string
  default     = "1.24.6-aliyun.1"
}

output "CLUSTER_ID" {
  value       = module.kubernetes.cluster_id
  description = "The ID of the cluster"
}

output "KUBECONFIG" {
  value = module.kubernetes.kube_config
  sensitive = true
  description = "The KUBECONFIG of the cluster"
}