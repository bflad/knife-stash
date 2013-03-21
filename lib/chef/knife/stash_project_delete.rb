#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

require 'chef/knife/stash_base'

class Chef
  class Knife
    class StashProjectDelete < Knife

      include Knife::StashBase

      banner "knife stash project delete KEY (options)"
      category "stash"

      option :delete_repos,
          :short => "-d",
          :long => "--delete-repos",
          :description => "Delete all repositories in project.",
          :boolean => false

      def run
        $stdout.sync = true
        
        key = name_args.first

        if key.nil?
          ui.fatal "You need a project key!"
          show_usage
          exit 1
        end

        stash = get_stash_connection

        if get_config(:noop)
          ui.info "#{ui.color "Skipping project deletion process because --noop specified.", :red}"
        else
          if get_config(:delete_repos)
            url = "projects/#{key}/repos"
            response = stash.get url
            if response.success?
              get_all_values stash,url,response do |values|
                values.each do |repo|
                  repo_delete = StashRepoDelete.new
                  repo_delete.name_args = [ key, repo['name'] ]
                  repo_delete.run
                end
              end
            else
              display_stash_error "Could not delete Stash project repositories!", response
              exit 1
            end
          end
          response = stash.delete "projects/#{key}"
          if response.success?
            ui.info "Deleted Stash Project: #{key}"
          else
            display_stash_error "Could not delete Stash project!", response
            exit 1
          end
        end
        
      end

    end
  end
end
