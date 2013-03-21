#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

require 'chef/knife/stash_base'

class Chef
  class Knife
    class StashRepos < Knife

      include Knife::StashBase

      banner "knife stash repos (options)"
      category "stash"

      def run
        $stdout.sync = true

        stash = get_stash_connection
        url = "projects"
        project_response = stash.get url

        if project_response.success?
          get_all_values stash,url,project_response do |project_values|
            project_values.each do |project|
              url = "projects/#{project['key']}/repos"
              repo_response = stash.get url

              if repo_response.success?
                get_all_values stash,url,repo_response do |repo_values|
                  repo_values.each do |repo|
                    ui.info "#{project['key']}/#{repo['slug']}"
                  end
                end
              else
                display_stash_error "Could not list Stash project repositories!", repo_response
                exit 1
              end
            end
          end
        else
          display_stash_error "Could not list Stash projects!", project_response
          exit 1
        end
        
      end

    end
  end
end
