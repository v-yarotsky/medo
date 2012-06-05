require 'erb'

module GLI
  module Commands
    module HelpModules
      class CommandHelpFormat
        def initialize(command,app,basic_invocation)
          @basic_invocation = basic_invocation
          @app = app
          @command = command
        end

        def format
          command_wrapper = TextWrapper.new(Terminal.instance.size[0],4 + @command.name.to_s.size + 3)
          wrapper = TextWrapper.new(Terminal.instance.size[0],4)
          flags_and_switches = Hash[@command.topmost_ancestor.flags.merge(@command.topmost_ancestor.switches).select { |_,option| option.associated_command == @command }]
          options_description = OptionsFormatter.new(flags_and_switches).format
          commands_description = format_subcommands(@command)

          synopses = []
          one_line_usage = basic_usage(flags_and_switches)
          one_line_usage << @command.arguments_description
          if @command.commands.empty?
            synopses << one_line_usage
          else
            synopses = sorted_synopses(flags_and_switches)
            if @command.has_action?
              synopses.unshift(one_line_usage)
            end

          end

          COMMAND_HELP.result(binding)
        end

      private
        COMMAND_HELP = ERB.new(%q(NAME
    <%= @command.name %> - <%= command_wrapper.wrap(@command.description) %>

SYNOPSIS
<% synopses.each do |s| %>
    <%= s %>
<% end %>
<% unless @command.long_description.nil? %>

DESCRIPTION
    <%= wrapper.wrap(@command.long_description) %> 
<% end %>
<% if options_description.strip.length != 0 %>

COMMAND OPTIONS
<%= options_description %>
<% end %>
<% unless @command.commands.empty? %>

COMMANDS
<%= commands_description %>
<% end %>),nil,'<>')

        def command_with_subcommand_usage(sub,flags_and_switches,is_default_command)
          usage = basic_usage(flags_and_switches)
          sub_options = @command.flags.merge(@command.switches).select { |_,o| o.associated_command == sub }
          usage << sub_options.map { |option_name,option| 
            all_names = [option.name,Array(option.aliases)].flatten
            all_names.map { |_| 
              CommandLineOption.name_as_string(_,false) + (option.kind_of?(Flag) ? " #{option.argument_name }" : '')
            }.join('|')
          }.map { |_| "[#{_}]" }.sort.join(' ')
          usage << ' '
          if is_default_command
            usage << "[#{sub.name}]"
          else
            usage << sub.name.to_s
          end
          usage
        end
 
        def basic_usage(flags_and_switches)
          usage = @basic_invocation.dup
          usage << " [global options] #{path_to_command} "
          usage << "[command options] " unless global_flags_and_switches.empty?
          usage
        end
 
        def path_to_command
          path = []
          c = @command
          while c.kind_of? Command
            path.unshift(c.name)
            c = c.parent
          end
          path.join(' ')
        end
 
        def global_flags_and_switches
          @app.flags.merge(@app.switches)
        end
 
        def format_subcommands(command)
          commands_array = command.commands.values.sort.map { |cmd| 
            if command.get_default_command == cmd.name
              [cmd.names,cmd.description + " (default)"] 
            else
              [cmd.names,cmd.description] 
            end
          }
          if command.has_action?
            commands_array.unshift(["<default>",command.default_description])
          end
          formatter = ListFormatter.new(commands_array)
          StringIO.new.tap { |io| formatter.output(io) }.string
        end

        def sorted_synopses(flags_and_switches)
          synopses_command = {}
          @command.commands.each do |name,sub|
            default = @command.get_default_command == name
            synopsis = command_with_subcommand_usage(sub,flags_and_switches,default)
            synopses_command[synopsis] = sub
          end
          synopses = synopses_command.keys.sort { |one,two|
            if synopses_command[one].name == @command.get_default_command
              -1
            elsif synopses_command[two].name == @command.get_default_command
              1
            else
              synopses_command[one] <=> synopses_command[two]
            end
          }
        end
      end
    end
  end
end
