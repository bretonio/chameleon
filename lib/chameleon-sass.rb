module ChameleonSass
  VERSION = "0.7.0"
  DATE = "2016-06-21"

  class << self

    def load
      methods = {
        sass: 'add_sass_load_path',
        compass: 'register_compass',
        none: 'add_sass_load_path_to_env'
      }

      self.send(methods[defined_framework])
    end

    def project_path
      File.expand_path(File.join(File.dirname(__FILE__), '..'))
    end

    def assets_path
      File.join(project_path, 'assets')
    end

    def stylesheets_path
      File.join(assets_path, 'stylesheets')
    end

    def defined_framework
      compass? || sass? || :none
    end

    def compass?
      :compass if defined?(::Compass)
    end

    def sass?
      :sass if defined?(::Sass)
    end

    def register_compass
      ::Compass::Frameworks.register(
        'chameleon-sass',
        :path => project_path,
        :stylesheets_directory => stylesheets_path
      )
    end

    def add_sass_load_path
      ::Sass.load_paths << stylesheets_path
    end

    def add_sass_load_path_to_env
      ENV["SASS_PATH"] = [
        ENV["SASS_PATH"],
        stylesheets_path
      ].join(File::PATH_SEPARATOR)
    end

  end
end

ChameleonSass.load
