package selected

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
  util "github.com/rancher/terraform-github-rke2-install/test/tests"
)

func TestSelected(t *testing.T) {
	t.Parallel()
	directory := "selected"
	release := "v1.28.5+rke2r1"

	terraformVars := map[string]interface{}{
		"release": release,
		"path":    "./rke2",
	}
	terraformOptions := util.Setup(t, directory, terraformVars)

	defer util.Teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	newRelease := util.GetLatestRelease(t, "rancher", "rke2")
	newTerraformVars := map[string]interface{}{
		"release": newRelease,
		"path":    "./rke2",
	}
	newTerraformOptions := util.Setup(t, directory, newTerraformVars)
	terraform.InitAndApply(t, newTerraformOptions)
}
