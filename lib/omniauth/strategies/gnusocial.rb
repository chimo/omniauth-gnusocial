require 'omniauth-oauth'
require 'json'

module OmniAuth
  module Strategies
    class GNUsocial < OmniAuth::Strategies::OAuth

      # I'm probably doing this very wrong...
      # I need to learn ruby at some point.
      def initialize(app, *args, &block)
        super

        @server = @options.server

        options[:client_options] = {:authorize_path => '/oauth/authorize',
                                 :site => "#{@server}/api",
                                 :proxy => ENV['http_proxy'] ? URI(ENV['http_proxy']) : nil}
      end

      option :name, 'gnusocial'

      uid { access_token.params[:user_id] }

      info do
        {
          :nickname => raw_info['screen_name'],
          :name => raw_info['name'],
          :email => raw_info["email"],
          :location => raw_info['location'],
          :image => image_url,
          :description => raw_info['description'],
          :urls => {
            'Website' => raw_info['url'],
            'GNUsocial' => "#{options.server}/#{raw_info['screen_name']}",
          }
        }
      end

      extra do
        skip_info? ? {} : { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= JSON.load(access_token.get('/account/verify_credentials.json').body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      alias :old_request_phase :request_phase

      def request_phase
        %w[force_login lang screen_name].each do |v|
          if request.params[v]
            options[:authorize_params][v.to_sym] = request.params[v]
          end
        end

        %w[x_auth_access_type].each do |v|
          if request.params[v]
            options[:request_params][v.to_sym] = request.params[v]
          end
        end

        if options[:use_authorize] || request.params['use_authorize'] == 'true'
          options[:client_options][:authorize_path] = '/oauth/authorize'
        else
          options[:client_options][:authorize_path] = '/oauth/authenticate'
        end

        old_request_phase
      end

      alias :old_callback_url :callback_url

      def callback_url
        if request.params['callback_url']
          request.params['callback_url']
        else
          old_callback_url
        end
      end

      def callback_path
        params = session['omniauth.params']

        if params.nil? || params['callback_url'].nil?
          super
        else
          URI(params['callback_url']).path
        end
      end

      private

      def image_url
        original_url = options[:secure_image_url] ? raw_info['profile_image_url_https'] : raw_info['profile_image_url']
        case options[:image_size]
        when 'mini'
          original_url.sub('normal', 'mini')
        when 'bigger'
          original_url.sub('normal', 'bigger')
        when 'original'
          original_url.sub('_normal', '')
        else
          original_url
        end
      end

    end
  end
end

OmniAuth.config.add_camelization 'gnusocial', 'GNUsocial'
