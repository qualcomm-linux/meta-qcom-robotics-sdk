# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
import yaml
import os
import requests
import subprocess
import sys
import tempfile


class Patch:
    """
    Class Patch contains detailed info that a patch should be applied.

    Params:
    - project: repo project name.
    - project_path: path of a repo project.
    - patch_info: patch data saved from yaml file.
    - ws: path of absolute source tree workspace.
    - patches_dir: path of the local patch.
    - patch_file: absolute path of a patch with patch name.
    """
    def __init__(self, project, project_path, patch_info, ws, patches_dir):
        self.project = project
        self.project_path = project_path
        self.patch_info = patch_info
        self.ws = ws
        self.patches_dir = patches_dir
        self.patch_file = None

    def download_patch(self, url):
        response = requests.get(url)
        self.patch_file = os.path.join(self.patches_dir, os.path.basename(url))
        with open(self.patch_file, 'wb') as file:
            file.write(response.content)

    def apply_patch(self):
        os.chdir(self.project_path)

        # Check that the patch can be applied
        result = subprocess.run(['git', 'apply', '--check', self.patch_file], capture_output=True, text=True)
        if result.returncode != 0:
            print(f"Patch {self.patch_file} has conflicts with the source.")
            print(f"Error details: {result.stderr}")
            return False

        result = subprocess.run(['git', 'apply', self.patch_file], capture_output=True, text=True)
        if result.returncode != 0:
            print(f"Failed to apply patch {self.patch_file}.")
            print(f"Error details: {result.stderr}")
            subprocess.run(['git', 'checkout', '-'], check=True)  # Restore changes
            os.chdir('..')
            return False

        print(f"Processing {self.patch_file} for project {self.project}: {self.project_path}.")

        os.chdir('..')
        return True

    def revert(self):
        print(f"Reverting {self.project}")
        os.chdir(self.project_path)
        subprocess.run(['git', 'checkout', '.'], check=True)
        subprocess.run(['git', 'clean', '-df'], check=True)
        os.chdir('..')

    def process(self):
        if 'patch_url' in self.patch_info:
            self.download_patch(self.patch_info['patch_url'])
        elif 'patch_path' in self.patch_info:
            if not self.patch_info['patch_path'].startswith('/'):
            # If the path not starts with '/', it's a related path.
            # Add Source tree prefix here.
                self.patch_file = os.path.join(self.ws, self.patch_info['patch_path'])
            else:
                self.patch_file = self.patch_info['patch_path']
            print(f"Local patch: {self.patch_file}")

        return self.apply_patch()

def print_usage():
    print("Usage: python script.py <yaml_file> <src_tree_path>")
    print("  <yaml_file>  Path to the YAML file containing patch information")
    print("  <src_tree_path>  *Absolute* path to the source tree")

def main():
    if len(sys.argv) != 3:
        print_usage()
        sys.exit(1)

    # Parse yaml file
    yaml_file = sys.argv[1]

    if not os.path.isfile(yaml_file):
        print(f"Error: File '{yaml_file}' not found.")
        print_usage()
        sys.exit(1)

    with open(yaml_file, 'r') as file:
        data = yaml.safe_load(file)

    # Path of workspace
    ws = sys.argv[2]
    print(f"ws: {ws}")

    # Create a temporary directory for patches
    patches_dir = tempfile.mkdtemp(prefix="patches_", dir="/tmp")

    print(f"Patches will be saved in: {patches_dir}")

    for project, details in data['patches'].items():
        project_path = details['path']
        patches = details['patches']
        applied_patches = []

        if not project_path.startswith('/'):
            # If the path not starts with '/', it's a related path.
            # Add Source tree prefix here.
            project_path = os.path.join(ws, project_path)
        print(f"project_path: {project_path}")

        for patch_info in patches:
            patch = Patch(project, project_path, patch_info, ws, patches_dir)
            if not patch.process():
                print(f"Reverting {project}")
                os.chdir(project_path)
                subprocess.run(['git', 'checkout', '.'], check=True)
                subprocess.run(['git', 'clean', '-df'], check=True)
                sys.exit(1)
            applied_patches.append(patch)

if __name__ == "__main__":
    main()
