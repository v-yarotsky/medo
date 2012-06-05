module GLI
  # The primary DSL for GLI.  This represents the methods shared between your top-level app and
  # the commands.  See GLI::Command for additional methods that apply only to command objects.
  module DSL
    # Describe the next switch, flag, or command.  This should be a
    # short, one-line description
    #
    # +description+:: A String of the short descripiton of the switch, flag, or command following
    def desc(description); @next_desc = description; end
    alias :d :desc

    # Provide a longer, more detailed description.  This
    # will be reformatted and wrapped to fit in the terminal's columns
    #
    # +long_desc+:: A String that is s longer description of the switch, flag, or command following.
    def long_desc(long_desc); @next_long_desc = long_desc; end

    # Describe the argument name of the next flag.  It's important to keep
    # this VERY short and, ideally, without any spaces (see Example).
    #
    # +name+:: A String that *briefly* describes the argument given to the following command or flag.
    #
    # Example:
    #     desc 'Set the filename'
    #     arg_name 'file_name'
    #     flag [:f,:filename]
    #
    # Produces:
    #     -f, --filename=file_name      Set the filename
    def arg_name(name); @next_arg_name = name; end

    # set the default value of the next flag
    #
    # +val+:: A String reprensenting the default value to be used for the following flag if the user doesn't specify one
    #         and, when using a config file, the config also doesn't specify one
    def default_value(val); @next_default_value = val; end

    # Create a flag, which is a switch that takes an argument
    #
    # +names+:: a String or Symbol, or an Array of String or Symbol that represent all the different names
    #           and aliases for this flag.  The last element can be a hash of options:
    #           +:desc+:: the description, instead of using #desc
    #           +:long_desc+:: the long_description, instead of using #long_desc
    #           +:default_value+:: the default value, instead of using #default_value
    #           +:arg_name+:: the arg name, instead of using #arg_name
    #           +:must_match+:: A regexp that the flag's value must match
    #           +:type+:: A Class (or object you passed to GLI::App#accept) to trigger type coversion
    #
    # Example:
    #
    #     desc 'Set the filename'
    #     flag [:f,:filename,'file-name']
    #
    #     flag :ipaddress, :desc => "IP Address", :must_match => /\d+\.\d+\.\d+\.\d+/
    #
    #     flag :names, :desc => "list of names", :type => Array
    #
    # Produces:
    #
    #     -f, --filename, --file-name=arg     Set the filename
    def flag(*names)
      options = extract_options(names)
      names = [names].flatten

      verify_unused(names)
      flag = Flag.new(names,options)
      flags[flag.name] = flag

      clear_nexts
      flag
    end
    alias :f :flag

    # Create a switch, which is a command line flag that takes no arguments (thus, it _switches_ something on)
    #
    # +names+:: a String or Symbol, or an Array of String or Symbol that represent all the different names
    #           and aliases for this switch.  The last element can be a hash of options:
    #           +:desc+:: the description, instead of using #desc
    #           +:long_desc+:: the long_description, instead of using #long_desc
    #           +:negatable+:: if true, this switch will get a negatable form (e.g. <tt>--[no-]switch</tt>, false it will not.  Default is true
    def switch(*names)
      options = extract_options(names)
      names = [names].flatten

      verify_unused(names)
      switch = Switch.new(names,options)
      switches[switch.name] = switch

      clear_nexts
      switch
    end
    alias :s :switch

    def clear_nexts # :nodoc:
      @next_desc = nil
      @next_arg_name = nil
      @next_default_value = nil
      @next_long_desc = nil
    end

    # Define a new command.  This can be done in a few ways, but the most common method is
    # to pass a symbol (or Array of symbols) representing the command name (or names) and a block.  
    # The block will be given an instance of the Command that was created.
    # You then may call methods on this object to define aspects of that Command.
    #
    # Alternatively, you can call this with a one element Hash, where the key is the symbol representing the name
    # of the command, and the value being an Array of symbols representing the commands to call in order, as a 
    # chained or compound command.  Note that these commands must exist already, and that only those command-specific
    # options defined in *this* command will be parsed and passed to the chained commands.  This might not be what you expect
    #
    # +names+:: a String or Symbol, or an Array of String or Symbol that represent all the different names and aliases 
    #           for this command *or* a Hash, as described above.
    #
    # ==Examples
    #
    #     # Make a command named list
    #     command :list do |c|
    #       c.action do |global_options,options,args|
    #         # your command code
    #       end
    #     end
    #
    #     # Make a command named list, callable by ls as well
    #     command [:list,:ls] do |c|
    #       c.action do |global_options,options,args|
    #         # your command code
    #       end
    #     end
    #
    #     # Make a command named all, that calls list and list_contexts
    #     command :all => [ :list, :list_contexts ]
    #
    #     # Make a command named all, aliased as :a:, that calls list and list_contexts
    #     command [:all,:a] => [ :list, :list_contexts ]
    #
    def command(*names)
      command_options = {
        :description => @next_desc,
        :arguments_name => @next_arg_name,
        :long_desc => @next_long_desc,
        :skips_pre => @skips_pre,
        :skips_post => @skips_post,
      }
      if names.first.kind_of? Hash
        command = GLI::Commands::CompoundCommand.new(self,
                                                     names.first,
                                                     command_options)
        command.parent = self
        commands[command.name] = command
      else
        command = Command.new(command_options.merge(:names => [names].flatten))
        command.parent = self
        commands[command.name] = command
        yield command
      end
      clear_nexts
    end
    alias :c :command

    private
    # Checks that the names passed in have not been used in another flag or option
    def verify_unused(names) # :nodoc:
      names.each do |name|
        verify_unused_in_option(name,flags,"flag")
        verify_unused_in_option(name,switches,"switch")
      end
    end

    def verify_unused_in_option(name,option_like,type) # :nodoc:
      return if name.to_s == 'help'
      raise ArgumentError.new("#{name} has already been specified as a #{type} #{context_description}") if option_like[name]
      option_like.each do |one_option_name,one_option|
        if one_option.aliases
          if one_option.aliases.include? name
            raise ArgumentError.new("#{name} has already been specified as an alias of #{type} #{one_option_name} #{context_description}") 
          end
        end
      end
    end

    # Extract the options hash out of the argument to flag/switch and
    # set the values if using classic style
    def extract_options(names)
      options = {}
      options = names.pop if names.last.kind_of? Hash
      options = { :desc => @next_desc, 
                  :long_desc => @next_long_desc,
                  :default_value => @next_default_value,
                  :arg_name => @next_arg_name}.merge(options)
    end


  end
end
