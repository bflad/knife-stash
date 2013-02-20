#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

module StashKnifePlugin

  require 'chef/knife'

  class StashProjects < BaseStashCommand

    banner "knife stash projects (options)"
    category "stash"

    get_common_options

    def run
      
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
