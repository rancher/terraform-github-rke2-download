package basic

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	util "github.com/rancher/terraform-github-rke2-download/test"
)

func TestBasic(t *testing.T) {
	t.Parallel()
	directory := "basic"
	// release := getLatestRelease(t, "rancher", "rke2")
	// terraformVars := map[string]any{
	// 	"release": release,
	// }
	terraformVars := map[string]any{}
	terraformOptions := util.Setup(t, directory, terraformVars)

	defer util.Teardown(t, directory)
	defer terraform.DestroyContext(t, t.Context(), terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
