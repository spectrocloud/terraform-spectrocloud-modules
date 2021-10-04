# Spectro Cloud credentials
sc_host         = "api.dev.spectrocloud.com" #e.g: api.spectrocloud.com (for SaaS)
sc_username     = "nikolay@spectrocloud.com" #e.g: user1@abc.com
sc_password     = "welcome2Spectro1!"        #e.g: supereSecure1!
sc_project_name = "Default"                  #e.g: Default

# AWS Cloud Account credentials
# Ensure minimum AWS account permissions:
# https://docs.spectrocloud.com/clusters/?clusterType=aws_cluster#awscloudaccountpermissions
aws_access_key = "AKIATD5NORWYBOSHBQE4"
aws_secret_key = "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"

# Existing SSH Key in AWS
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
aws_ssh_key_name = "spectro2020" #e.g: default

# Enter the AWS Region and AZ for cluster resources
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions
aws_region    = "us-west-2"  #e.g: us-west-2
aws_region_az = "us-west-2a" #e.g: us-west-2a

cluster_files = ["./config/cluster-eks-test.yaml"]
