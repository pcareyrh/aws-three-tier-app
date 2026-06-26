resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "3.4.0"  # verify latest

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "region"
    value = "ap-southeast-2"
  }
  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }
  # No serviceAccount.annotations role-arn needed anymore
  depends_on = [
    module.aws_lb_controller_pod_identity
  ]
}