#
# Author:: Brian Flad (<bflad417@gmail.com>)
# License:: Apache License, Version 2.0
#

require 'chef/knife'
require 'highline/import'
require 'faraday'

class Chef
  class Knife
    module StashBase

      def self.included(includer)
        includer.class_eval do

          deps do
            require 'readline'
            require 'chef/json_compat'
          end

          unless defined? $default
            $default = Hash.new
          end

          option :noop,
            :long => "--noop",
            :description => "Perform no modifying operations",
            :boolean => false

          option :stash_username,
            :short => "-u USERNAME",
            :long => "--stash-username USERNAME",
            :description => "The username for Stash"
          $default[:stash_username] = ENV['USER']

          option :stash_password,
            :short => "-p PASSWORD",
            :long => "--stash-password PASSWORD",
            :description => "The password for Stash"

      		option :stash_hostname,
      			:long => "--stash-hostname HOSTNAME",
      			:description => "The hostname for Stash"
        end
    	end

      def display_stash_error(message,response)
        ui.fatal message
        JSON.parse(response.body)['errors'].each do |error|
          ui.fatal "#{error['context'] ? error['context'] + ": " : "" }#{error['message']}"
        end
      end

      def get_all_values(stash,url,response)
        r = JSON.parse(response.body)
        yield r['values']
        until r['isLastPage']
          response = stash.get url, { :start => r['nextPageStart'] }
          r = JSON.parse(response.body)
          yield r['values']
        end
      end

    	def get_config(key)
    		key = key.to_sym
    		rval = config[key] || Chef::Config[:knife][key] || $default[key]
    		Chef::Log.debug("value for config item #{key}: #{rval}")
    		rval
    	end

    	def get_stash_connection
        config[:stash_hostname] = ask("Stash Hostname: ") { |q| q.echo = "*" } unless get_config(:stash_hostname)
        config[:stash_username] = ask("Stash Username for #{get_config(:stash_hostname)}: ") { |q| q.echo = "*" } unless get_config(:stash_username)
        config[:stash_password] = ask("Stash Password for #{get_config(:stash_username)}: ") { |q| q.echo = "*" } unless get_config(:stash_password)
        
        connection = Faraday.new(:url => "https://#{get_config(:stash_hostname)}", :ssl => {:verify => false}) do |faraday|
          faraday.request  :url_encoded # form-encode POST params
          #faraday.response :logger      # log requests to STDOUT
          faraday.adapter  :net_http    # make requests with Net::HTTP
        end
        connection.basic_auth(get_config(:stash_username),get_config(:stash_password))
        connection.url_prefix = "https://#{get_config(:stash_hostname)}/rest/api/1.0"
        connection
    	end

      def get_repo_https_url(project_key,repo)
        "https://#{get_config(:stash_username)}@#{get_config(:stash_hostname)}/scm/#{project_key}/#{repo}.git"
      end

      def get_repo_ssh_url(project_key,repo)
        "ssh://git@#{get_config(:stash_hostname)}:7999/#{project_key}/#{repo}.git"
      end

    end
  end
end
