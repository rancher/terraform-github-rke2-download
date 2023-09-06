package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestBasic(t *testing.T) {
	t.Parallel()
	directory := "basic"
	// release := getLatestRelease(t, "rancher", "rke2")
	// terraformVars := map[string]interface{}{
	// 	"release": release,
	// }
	terraformVars := map[string]interface{}{}
	terraformOptions := setup(t, directory, terraformVars)

	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
