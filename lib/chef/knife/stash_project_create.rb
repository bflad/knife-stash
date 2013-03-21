#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

require 'chef/knife/stash_base'

class Chef
  class Knife
    class StashProjectCreate < Knife

      include Knife::StashBase

      banner "knife stash project create KEY NAME (options)"
      category "stash"

      option :description,
          :short => "-d DESCRIPTION",
          :long => "--description DESCRIPTION",
          :description => "The description for the project"

      def run
        $stdout.sync = true
        
        key = name_args.first

        if key.nil?
          ui.fatal "You need a project key!"
          show_usage
          exit 1
        end

        name = name_args[1]

        if name.nil?
          ui.fatal "You need a project name!"
          show_usage
          exit 1
        end

        args = name_args[2]
        if args.nil?
          args = ""
        end

        stash = get_stash_connection
        project = { :name => name, :key => key }
        project[:description] = get_config(:description) if get_config(:description)

        if get_config(:noop)
          ui.info "#{ui.color "Skipping project creation process because --noop specified.", :red}"
        else
          response = stash.post do |post|
            post.url "projects"
            post.headers['Content-Type'] = "application/json"
            post.body = JSON.generate(project)
          end
          if response.success?
            ui.info "Created Stash Project: #{key} (#{name})"
          else
            display_stash_error "Could not create Stash project!", response
            exit 1
          end
        end
        
      end

    end
  end
end
