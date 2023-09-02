
# use "aws eks describe-addon-versions --addon-name aws-ebs-csi-driver" command to find out latest version and copy it to below script. this script will install CSI driver
resource "aws_eks_addon" "csi_driver" {
  cluster_name = aws_eks_cluster.eks-cluster-1.name
  #  cluster_name             = aws_eks_cluster.demo.name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = "v1.21.0-eksbuild.1"
  #  addon_version            = "v1.11.4-eksbuild.1"
  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
}