package testutils

import (
	"github.com/gruntwork-io/terratest/modules/files"
	"log"
	"os"
	"testing"
)

func SetupTest(tb testing.TB, testPath string) func(tb testing.TB) {
	log.Println("setup test")
	tempTestProviderFilePath := testPath + "/test-provider.tf"
	//noinspection GoUnhandledErrorResult
	files.CopyFile("../test-provider.tf", tempTestProviderFilePath)

	return func(tb testing.TB) {
		log.Println("teardown test")
		//noinspection GoUnhandledErrorResult
		defer os.Remove(tempTestProviderFilePath)

	}
}
