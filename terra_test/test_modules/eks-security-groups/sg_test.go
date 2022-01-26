package eks_security_groups

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/stretchr/testify/assert"
	"terraform-eks-with-monitoring/terra_test/testutils"
	"testing"
)
import (
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestEksClusterSG(t *testing.T) {
	svc := ec2.New(session.New(), &aws.Config{
		Region: aws.String("us-west-2")})
	input := &ec2.DescribeVpcsInput{}

	result, err := svc.DescribeVpcs(input)
	if err != nil {

	}
	opts := &terraform.Options{
		// You should update this relative path to point at your alb
		// example directory!
		TerraformDir: "../../../modules/eks-security-groups",
		Vars: map[string]interface{}{
			"name":        "test123",
			"environment": "unit_test",
			"vpc_id":      *result.Vpcs[0].VpcId,
		},
	}
	path := opts.TerraformDir
	teardownTest := testutils.SetupTest(t, path)
	defer teardownTest(t)
	// Deploy the example
	terraform.Init(t, opts)
	terraform.Apply(t, opts)
	sgName := terraform.Output(t, opts, "eks_cluster_sg_name")
	assert.Equal(t, "eks-cluster-security-group", sgName)
	defer terraform.Destroy(t, opts)

}
