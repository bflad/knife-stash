#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

require 'chef/knife/stash_base'

class Chef
  class Knife
    class StashProjects < Knife

      include Knife::StashBase

      banner "knife stash projects (options)"
      category "stash"

      def run
        $stdout.sync = true
        
        stash = get_stash_connection
        url = "projects"
        response = stash.get url

        if response.success?
          get_all_values stash,url,response do |values|
            values.each do |project|
              ui.info "#{project['key']}: #{project['name']}"
            end
          end
        else
          display_stash_error "Could not list Stash projects!", response
          exit 1
        end
        
      end

    end
  end
end
