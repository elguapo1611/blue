module Blue
  module Template

    def self.included(klass)
      klass.class_eval do
        def local_template_dir
          @local_template_dir ||= Pathname.new(Blue.rails_current + '/app/manifests/templates')
        end

        def local_template(pathname)
         (local_template_dir + pathname.basename).expand_path
        end

        # Render the ERB template located at <tt>pathname</tt>. If a template exists
        # with the same basename at <tt>RAILS_ROOT/app/manifests/templates</tt>, it
        # is used instead. This is useful to override templates provided by plugins
        # to customize application configuration files.
        def template(pathname, b = binding)
          pathname = Pathname.new(pathname) unless pathname.kind_of?(Pathname)

          pathname = if local_template(pathname).exist?
                       local_template(pathname)
                     elsif pathname.exist?
                       pathname
                     else
                       raise LoadError, "Can't find template #{pathname}"
                     end
          erb = ERB.new(pathname.read)
          erb.filename = pathname.to_s
          erb.result(b)
        end
      end
    end

    def template(pathname, b = binding)
      self.class.template(pathname, b)
    end
  end
end

