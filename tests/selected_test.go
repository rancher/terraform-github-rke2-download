package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestSelected(t *testing.T) {
	t.Parallel()
	directory := "selected"
	release := getLatestRelease(t, "rancher", "rke2")
	terraformVars := map[string]interface{}{
		"release": release,
		"path":    "./rke2",
	}
	terraformOptions := setup(t, directory, terraformVars)

	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
