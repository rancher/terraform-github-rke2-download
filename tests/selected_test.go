package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestSelected(t *testing.T) {
	t.Parallel()
	directory := "selected"
	release := "v1.28.5+rke2r1"

	terraformVars := map[string]interface{}{
		"release": release,
		"path":    "./rke2",
	}
	terraformOptions := setup(t, directory, terraformVars)

	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	newRelease := getLatestRelease(t, "rancher", "rke2")
	newTerraformVars := map[string]interface{}{
		"release": newRelease,
		"path":    "./rke2",
	}
	newTerraformOptions := setup(t, directory, newTerraformVars)
	terraform.InitAndApply(t, newTerraformOptions)
}
