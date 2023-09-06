package test

import (
	"context"
	"fmt"
	"os"
	"testing"

	"github.com/google/go-github/v53/github"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func teardown(t *testing.T, directory string) {
	err := os.RemoveAll(fmt.Sprintf("../examples/%s/.terraform", directory))
	require.NoError(t, err)
	err2 := os.RemoveAll(fmt.Sprintf("../examples/%s/rke2", directory))
	require.NoError(t, err2)
	err3 := os.RemoveAll(fmt.Sprintf("../examples/%s/tmp", directory))
	require.NoError(t, err3)
	err4 := os.RemoveAll(fmt.Sprintf("../examples/%s/.terraform.lock.hcl", directory))
	require.NoError(t, err4)
	err5 := os.RemoveAll(fmt.Sprintf("../examples/%s/terraform.tfstate", directory))
	require.NoError(t, err5)
	err6 := os.RemoveAll(fmt.Sprintf("../examples/%s/terraform.tfstate.backup", directory))
	require.NoError(t, err6)
}

func setup(t *testing.T, directory string, terraformVars map[string]interface{}) *terraform.Options {

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
		TerraformDir: fmt.Sprintf("../examples/%s", directory),
		// Variables to pass to our Terraform code using -var options
		Vars:                     terraformVars,
		RetryableTerraformErrors: retryableTerraformErrors,
	})
	return terraformOptions
}

func getLatestRelease(t *testing.T, owner string, repo string) string {
	ghClient := github.NewClient(nil)
	release, _, err := ghClient.Repositories.GetLatestRelease(context.Background(), owner, repo)
	require.NoError(t, err)
	version := *release.TagName
	return version
}
