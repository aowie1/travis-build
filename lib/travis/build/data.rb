require 'core_ext/hash/deep_merge'
require 'core_ext/hash/deep_symbolize_keys'

# actually, the worker payload can be cleaned up a lot ...

module Travis
  module Build
    class Data
      autoload :Env, 'travis/build/data/env'
      autoload :Var, 'travis/build/data/var'

      DEFAULTS = {
        timeouts: {
          git_clone:      300,
          git_fetch_ref:  300,
          git_submodules: 300,
          start_service:  60,
          before_install: 300,
          install:        600,
          before_script:  600,
          script:         1500,
          after_success:  300,
          after_failure:  300,
          after_script:   300
        }
      }

      attr_reader :data

      def initialize(data, defaults = {})
        data = data.deep_symbolize_keys
        defaults = defaults.deep_symbolize_keys
        @data = DEFAULTS.deep_merge(defaults.deep_merge(data))
      end

      def urls
        data[:urls] || {}
      end

      def timeouts
        data[:timeouts] || {}
      end

      def config
        data[:config]
      end

      def env_vars
        @env_vars ||= Env.new(self).vars
      end

      def pull_request
        job[:pull_request]
      end

      def source_url
        repository[:source_url]
      end

      def slug
        repository[:slug]
      end

      def commit
        job[:commit]
      end

      def ref
        job[:ref]
      end

      def job
        data[:job] || {}
      end

      def build
        data[:source] || data[:build] || {} # TODO standarize the payload on :build
      end

      def repository
        data[:repository] || {}
      end
    end
  end
end
