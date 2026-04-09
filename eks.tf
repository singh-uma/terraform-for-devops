module "eks" {

 #import the module and specify the source and version
  source = "terraform-aws-modules/eks/aws"
   version = "~> 20.0" 
  
# specify the cluster name, version, and endpoint access
  cluster_name = local.name
  cluster_version = "1.29"
  cluster_endpoint_public_access = true

# specify the VPC and subnets for the cluster
   vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    control_plane_subnet_ids = module.vpc.intra_subnets
# specify the cluster addons and their versions
    #cluster_addons = {
       # vpc_cni = {
          #  most_recent = true
      #  }
       # kube_proxy = {
          #  most_recent = true
      #  }
      #  coredns = {
      #      most_recent = true
      #  }
   # }
    #Managing the node group defaults and node group configuration
    eks_managed_node_group_defaults = {
        instance_types = ["t2.medium"]
        attach_cluster_primary_security_group = true
    }

    eks_managed_node_groups = {
        cluster_nodes = {
            instance_types = ["t2.medium"]
            min_size = 2
            max_size = 3
            desired_size = 2
            capacity_type = "SPOT"
        }
    }

    tags = {
        Environment = local.env
        Terraform = "true"
    }

}