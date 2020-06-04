output "master_public_dns" {
  value       = join("", aws_emr_cluster.cluster.*.master_public_dns)
  description = "Master public DNS"
}
