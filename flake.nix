{
  description = "A reliable testing environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux" ]
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          leftovers-version = {
            "selected" = "v0.70.0";
          };
          leftovers-prep = {
            "x86_64-darwin" = {
              "url" = "https://github.com/genevieve/leftovers/releases/download/${leftovers-version.selected}/leftovers-${leftovers-version.selected}-darwin-amd64";
              "sha" = "sha256-HV12kHqB14lGDm1rh9nD1n7Jvw0rCnxmjC9gusw7jfo=";
            };
            "aarch64-darwin" = {
              "url" = "https://github.com/genevieve/leftovers/releases/download/${leftovers-version.selected}/leftovers-${leftovers-version.selected}-darwin-arm64";
              "sha" = "sha256-Tw7G538RYZrwIauN7kI68u6aKS4d/0Efh+dirL/kzoM=";
            };
            "x86_64-linux" = {
              "url" = "https://github.com/genevieve/leftovers/releases/download/${leftovers-version.selected}/leftovers-${leftovers-version.selected}-linux-amd64";
              "sha" = "sha256-D2OPjLlV5xR3f+dVHu0ld6bQajD5Rv9GLCMCk9hXlu8=";
            };
            "aarch64-linux" = {
              "url" = "https://github.com/genevieve/leftovers/releases/download/${leftovers-version.selected}/leftovers-${leftovers-version.selected}-linux-arm64";
              "sha" = "sha256-qE1s3rUItGkP5o+yJ/1h20M0wXjN9r5R6s5wU+0i8oE=";
            };
          };
          leftovers = pkgs.stdenv.mkDerivation {
            name = "leftovers-${leftovers-version.selected}";
            src = pkgs.fetchurl {
              url = leftovers-prep."${system}".url;
              sha256 = leftovers-prep."${system}".sha;
            };
            phases = [ "installPhase" ];
            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/leftovers
              chmod +x $out/bin/leftovers
            '';
          };

          terraform-version = {
            "selected" = "1.5.7";
          };
          terraform-prep = {
            "aarch64-darwin" = {
              "url" = "https://releases.hashicorp.com/terraform/${terraform-version.selected}/terraform_${terraform-version.selected}_darwin_arm64.zip";
              "sha" = "sha256-23wz6xpEa3OkQ+LFW1MoRfe3DNVhAL7EyW8Vz6tfUMs=";
              "checksum" = "db7c33eb1a446b73a443e2c55b532845f7b70cd56100bec4c96f15cfab5f50cb";
            };
            "x86_64-darwin" = {
              "url" = "https://releases.hashicorp.com/terraform/${terraform-version.selected}/terraform_${terraform-version.selected}_darwin_amd64.zip";
              "sha" = "sha256-jC54Ew5I7tNhlxH1sD8qN63G0d9M/Z1wZJ3kO9L1I0M=";
              "checksum" = "841b8992f03f385c7bb9d4e5f7af8d9c20a4c2847a9649987820bb29124edc84";
            };
            "x86_64-linux" = {
              "url" = "https://releases.hashicorp.com/terraform/${terraform-version.selected}/terraform_${terraform-version.selected}_linux_amd64.zip";
              "sha" = "sha256-wO17wy7lKuJVr5mCyMiKekxhBIXPHVX+6wN+q3X6CCw=";
              "checksum" = "c0ed7bc32ee52ae255af9982c8c88a7a4c610485cf1d55feeb037eab75fa082c";
            };
            # linux container running on darwin or arm linux
            "aarch64-linux" = {
              "url" = "https://releases.hashicorp.com/terraform/${terraform-version.selected}/terraform_${terraform-version.selected}_linux_arm64.zip";
              "sha" = "sha256-9LStfGtgiJYKZn40SVyuSQ+wcpR6n/Jmv1kp9TM1ZeQ=";
              "checksum" = "f4b4ad7c6b6088960a667e34495cae490fb072947a9ff266bf5929f5333565e4";
            };
          };
          terraform = pkgs.stdenv.mkDerivation {
            name = "terraform-${terraform-version.selected}";
            src = pkgs.fetchurl {
              url = terraform-prep."${system}".url;
              sha256 = terraform-prep."${system}".sha;
            };
            checksum = terraform-prep."${system}".checksum;
            nativeBuildInputs = [ pkgs.unzip ];
            phases = [ "installPhase" ];
            installPhase = ''
              echo "$checksum  $src" | sha256sum -c -
              install -d $out/bin
              unzip -o $src -d $out/bin
              chmod +x $out/bin/terraform
            '';
          };

          devPackages = [
            leftovers
            terraform
          ] ++ (with pkgs; [
            actionlint
            bashInteractive
            cmctl
            cspell
            curl
            dig
            gh
            git
            gitleaks
            gnupg
            go
            gotestfmt
            gotestsum
            golangci-lint
            kubernetes-helm
            jq
            kubectl
            k8sgpt
            less
            openssh
            openssl
            pup
            shellcheck
            terraform-docs
            tflint
            tfsec
            updatecli
            vim
            which
            xan
            yq-go
          ]);

          devShellPackage = pkgs.symlinkJoin {
            name = "dev-shell-package";
            paths = devPackages;
          };

        in
        {
          packages.default = devShellPackage;

          devShells.default = pkgs.mkShell {
            buildInputs = [ devShellPackage ];
            shellHook = ''
              export PS1="nix:# ";
            '';
          };
        }
      );
}
