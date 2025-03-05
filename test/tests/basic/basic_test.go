package basic

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
  util "github.com/rancher/terraform-github-rke2-install/test/tests"
)

func TestBasic(t *testing.T) {
	t.Parallel()
	directory := "basic"
	// release := getLatestRelease(t, "rancher", "rke2")
	// terraformVars := map[string]interface{}{
	// 	"release": release,
	// }
	terraformVars := map[string]interface{}{}
	terraformOptions := util.Setup(t, directory, terraformVars)

	defer util.Teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
