#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

module StashKnifePlugin

  require 'chef/knife'

  class StashRepoDelete < BaseStashCommand

    banner "knife stash repo delete KEY REPO (options)"
    category "stash"

    get_common_options

    def run
      
      key = name_args.first

      if key.nil?
        ui.fatal "You need a project key!"
        show_usage
        exit 1
      end

      repo = name_args[1]

      if repo.nil?
        ui.fatal "You need a repository name!"
        show_usage
        exit 1
      end

      stash = get_stash_connection

      if get_config(:noop)
        ui.info "#{ui.color "Skipping project repository deletion process because --noop specified.", :red}"
      else
        response = stash.delete "projects/#{key}/repos/#{repo}"
        if response.success?
          ui.info "Deleted Stash Repository: #{key}/#{repo}"
        else
          display_stash_error "Could not delete Stash respository!", response
          exit 1
        end
      end
      
    end

  end
end
