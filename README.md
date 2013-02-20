# Knife Stash

A knife plugin for Atlassian Stash.

## Installation

* Clone repo to ~/.chef/plugins/knife or path/to/cheforg/.chef/plugins/knife

## Usage

Plugin will prompt for any missing passwords.

### Common parameters

* `--noop` - Perform no modifying operations
* `--stash-username USERNAME` - Stash username, defaults to
  `ENV['USER']`
* `--stash-password PASSWORD` - Stash password, defaults to nothing but will ask if necessary
* `--stash-hostname HOSTNAME` - Stash hostname, no default

### knife stash project create KEY NAME

Creates a Stash project.

* `--description DESCRIPTION` - optionally set a description for the project

For example:

    $ knife stash project create TEST "Test Project from API"
    Created Stash Project: TEST (Test Project from API)

### knife stash project delete KEY

Deletes a Stash project.

* `--delete-repos` - required if any repositories exist under project

For example:

    $ knife stash project delete TEST --delete-repos
    Deleted Stash Repository: TEST/repo1
    Deleted Stash Repository: TEST/repo2
    Deleted Stash Project: TEST

### knife stash project repos KEY

Lists all Stash repositories in a project.

    $ knife stash project repos COOKBOOKS
    cessna (cessna)
    netbackup (netbackup)
    remoteaddr (remoteaddr)
    template-cookbook (template-cookbook)
    ...

### knife stash projects

Lists all Stash projects.

    $ knife stash projects
    CHEF_BASEBOX: Chef Basebox
    COOKBOOKS: Chef Cookbooks
    CHEFORG_CORE_SYSTEMS: Chef Organization core-systems
    CHEFORG_FNCE: Chef Organization FNCE
    ...

### knife stash repo create KEY REPO

Creates a Stash repository in a project.

    $ knife stash repo create TEST repo1
    Created Stash Repository: TEST/repo1
    Available via (HTTPS): https://bflad@stash.example.com/scm/TEST/repo1.git
    Available via (SSH): ssh://git@stash.example.com:7999/TEST/repo1.git

### knife stash repo delete KEY REPO

Deletes a Stash repository in a project.

    $ knife stash repo delete TEST repo1
    Deleted Stash Repository: TEST/repo1

### knife stash repos

Lists all Stash repositories in all projects.

    $ knife stash repos
    CHEF_BASEBOX/definitions
    COOKBOOKS/cessna
    COOKBOOKS/netbackup
    COOKBOOKS/remoteaddr
    COOKBOOKS/template-cookbook
    CHEFORG_CORE_SYSTEMS/cheforg-core-systems
    CHEFORG_FNCE/cheforg_fnce
    ...

## Contributing

Please use standard Github issues and pull requests.

## License and Author

Author:: Brian Flad (<bflad417@gmail.com>)

Copyright:: 2013

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
