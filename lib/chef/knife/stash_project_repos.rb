#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

require 'chef/knife/stash_base'

class Chef
  class Knife
    class StashProjectRepos < Knife

      include Knife::StashBase

      banner "knife stash project repos KEY (options)"
      category "stash"

      def run
        $stdout.sync = true
        
        key = name_args.first

        if key.nil?
          ui.fatal "You need a project key!"
          show_usage
          exit 1
        end

        stash = get_stash_connection
        url = "projects/#{key}/repos"
        response = stash.get url

        if response.success?
          get_all_values stash,url,response do |values|
            values.each do |repo|
              ui.info "#{repo['slug']} (#{repo['name']})"
            end
          end
        else
          display_stash_error "Could not list Stash project repositories!", response
          exit 1
        end
        
      end

    end
  end
end
