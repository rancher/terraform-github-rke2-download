package test

import (
	"context"
	"fmt"
	"os"
  "path/filepath"
	"testing"

	"github.com/google/go-github/v53/github"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
  g "github.com/gruntwork-io/terratest/modules/git"
)

func Teardown(t *testing.T, directory string) {
  repoRoot, err0 := getRepoRoot(t)
  require.NoError(t, err0)
	err := os.RemoveAll(fmt.Sprintf("%s/examples/%s/.terraform", repoRoot, directory))
	require.NoError(t, err)
	err2 := os.RemoveAll(fmt.Sprintf("%s/examples/%s/rke2", repoRoot, directory))
	require.NoError(t, err2)
	err3 := os.RemoveAll(fmt.Sprintf("%s/examples/%s/tmp", repoRoot, directory))
	require.NoError(t, err3)
	err4 := os.RemoveAll(fmt.Sprintf("%s/examples/%s/.terraform.lock.hcl", repoRoot, directory))
	require.NoError(t, err4)
	err5 := os.RemoveAll(fmt.Sprintf("%s/examples/%s/terraform.tfstate", repoRoot, directory))
	require.NoError(t, err5)
	err6 := os.RemoveAll(fmt.Sprintf("%s/examples/%s/terraform.tfstate.backup", repoRoot, directory))
	require.NoError(t, err6)
}

func Setup(t *testing.T, directory string, terraformVars map[string]interface{}) *terraform.Options {
  repoRoot, err0 := getRepoRoot(t)
  require.NoError(t, err0)

  retryableTerraformErrors := map[string]string{
		// The reason is unknown, but eventually these succeed after a few retries.
		".*unable to verify signature.*":             "Failed due to transient network error.",
		".*unable to verify checksum.*":              "Failed due to transient network error.",
		".*no provider exists with the given name.*": "Failed due to transient network error.",
		".*registry service is unreachable.*":        "Failed due to transient network error.",
		".*connection reset by peer.*":               "Failed due to transient network error.",
		".*TLS handshake timeout.*":                  "Failed due to transient network error.",
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: fmt.Sprintf("%s/examples/%s", repoRoot, directory),
		// Variables to pass to our Terraform code using -var options
		Vars:                     terraformVars,
		RetryableTerraformErrors: retryableTerraformErrors,
	})
	return terraformOptions
}

func GetLatestRelease(t *testing.T, owner string, repo string) string {
	ghClient := github.NewClient(nil)
	release, _, err := ghClient.Repositories.GetLatestRelease(context.Background(), owner, repo)
	require.NoError(t, err)
	version := *release.TagName
	return version
}

func getRepoRoot(t *testing.T) (string, error) {
  gwd := g.GetRepoRoot(t)
  fwd, err := filepath.Abs(gwd)
  if err != nil {
    return "", err
  }
  return fwd, nil
}
