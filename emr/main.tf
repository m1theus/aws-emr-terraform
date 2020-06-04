resource "aws_emr_cluster" "cluster" {
  name          = "emr"
  release_label = "emr-5.26.0"
  applications = [
    "Hue",
    "JupyterHub",
    "Hive",
    "Spark",
    "Livy",
    "Zeppelin"
  ]

  # DETERMINE CLUSTER AWAITS
  keep_job_flow_alive_when_no_steps = true
  termination_protection            = false

  ec2_attributes {
    key_name                          = "uncrxd-key"
    subnet_id                         = "subnet-08adfaaee1b688f6c"
    emr_managed_master_security_group = "sg-0cfe8d8da550c18c2"
    emr_managed_slave_security_group  = "sg-0cfe8d8da550c18c2"
    instance_profile                  = "arn:aws:iam::478784202550:instance-profile/emr_profile1"
  }

  master_instance_type = "m5.xlarge"
  core_instance_type   = "m5.xlarge"
  core_instance_count  = 1

  tags = {
    role     = "rolename"
    dns_zone = "env_zone"
    env      = "env"
    name     = "name-env"
  }

  bootstrap_action {
    path = "s3://elasticmapreduce/bootstrap-actions/run-if"
    name = "runif"
    args = ["instance.isMaster=true", "echo running on master node"]
  }

  configurations_json = <<EOF
  [
    {
    "Classification": "spark",
    "Properties": {
      "maximizeResourceAllocation": "true"
    }
  },
  {
    "Classification": "yarn-site",
    "Properties": {
      "yarn.nodemanager.vmem-check-enabled": "false",
      "yarn.nodemanager.pmem-check-enabled": "false"
    }
  },
    {
      "Classification": "hadoop-env",
      "Configurations": [
        {
          "Classification": "export",
          "Properties": {
            "JAVA_HOME": "/usr/lib/jvm/java-1.8.0"
          }
        }
      ],
      "Properties": {}
    },
    {
      "Classification": "spark-env",
      "Configurations": [
        {
          "Classification": "export",
          "Properties": {
            "JAVA_HOME": "/usr/lib/jvm/java-1.8.0"
          }
        }
      ],
      "Properties": {}
    },
    {
    "Classification": "hive-site",
    "Properties": {
      "hive.metastore.client.factory.class": "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"
    }
  },
  {
    "Classification": "spark-hive-site",
    "Properties": {
      "hive.metastore.client.factory.class": "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"
    }
  }
  ]
EOF

  service_role = "arn:aws:iam::478784202550:role/iam_emr_service_role"
}
