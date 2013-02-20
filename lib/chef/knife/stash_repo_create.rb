#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

module StashKnifePlugin

  require 'chef/knife'

  class StashRepoCreate < BaseStashCommand

    banner "knife stash repo create PROJECT_KEY NAME (options)"
    category "stash"

    get_common_options

    def run
      
      project_key = name_args.first

      if project_key.nil?
        ui.fatal "You need a project key!"
        show_usage
        exit 1
      end

      name = name_args[1]

      if name.nil?
        ui.fatal "You need a repository name!"
        show_usage
        exit 1
      end

      args = name_args[2]
      if args.nil?
        args = ""
      end

      stash = get_stash_connection
      repo = { :name => name, :scmId => "git" }

      if get_config(:noop)
        ui.info "#{ui.color "Skipping repo creation process because --noop specified.", :red}"
      else
        response = stash.post do |post|
          post.url "projects/#{project_key}/repos"
          post.headers['Content-Type'] = "application/json"
          post.body = JSON.generate(repo)
        end
        if response.success?
          ui.info "Created Stash Repository: #{project_key}/#{name}"
          ui.info "Available via (HTTPS): #{get_repo_https_url(project_key,name)}"
          ui.info "Available via (SSH): #{get_repo_ssh_url(project_key,name)}"
        else
          display_stash_error "Could not create Stash repository!", response
          exit 1
        end
      end
      
    end

  end
end
