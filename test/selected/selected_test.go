package selected

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	util "github.com/rancher/terraform-github-rke2-download/test"
)

func TestSelected(t *testing.T) {
	t.Parallel()
	directory := "selected"
	release := "v1.28.5+rke2r1"

	terraformVars := map[string]any{
		"release": release,
		"path":    "./rke2",
	}
	terraformOptions := util.Setup(t, directory, terraformVars)

	defer util.Teardown(t, directory)
	defer terraform.DestroyContext(t, t.Context(), terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
	newRelease := util.GetLatestRelease(t, "rancher", "rke2")
	newTerraformVars := map[string]any{
		"release": newRelease,
		"path":    "./rke2",
	}
	newTerraformOptions := util.Setup(t, directory, newTerraformVars)
	terraform.InitAndApplyContext(t, t.Context(), newTerraformOptions)
}
