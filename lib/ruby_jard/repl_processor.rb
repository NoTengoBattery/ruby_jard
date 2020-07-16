# frozen_string_literal: true

module RubyJard
  ##
  # Byebug allows customizing processor with a series of hooks (https://github.com/deivid-rodriguez/byebug/blob/e1fb8209d56922f7bafd128af84e61568b6cd6a7/lib/byebug/processors/command_processor.rb)
  #
  # This class is a bridge between REPL library and Byebug. It is inherited from
  # Byebug::CommandProcessor, the processor is triggered. It starts draw the
  # UI, starts a new REPL session, listen for control-flow events threw from
  # repl, and triggers Byebug debugger if needed.
  #
  class ReplProcessor < Byebug::CommandProcessor
    def initialize(context, interface = LocalInterface.new)
      super(context, interface)
      key_bindings = RubyJard::KeyBindings.new
      push_navigation_bindings(key_bindings)
      @repl_proxy = RubyJard::ReplProxy.new(key_bindings: key_bindings)
    end

    def at_line
      process_commands
    end

    def at_return(_)
      process_commands
    end

    def at_end
      process_commands
    end

    private

    def process_commands
      RubyJard.current_session.refresh
      return_value = nil

      flow = RubyJard::ControlFlow.listen do
        return_value = allowing_other_threads do
          @repl_proxy.repl(frame._binding)
        end
      end

      unless flow.nil?
        command = flow.command
        send("handle_#{command}_command", flow.arguments)
      end

      return_value
    end

    def handle_next_command(_options = {})
      Byebug::NextCommand.new(self, 'next').execute
    end

    def handle_step_command(_options = {})
      Byebug::StepCommand.new(self, 'step').execute
    end

    def handle_up_command(_options = {})
      Byebug::UpCommand.new(self, 'up 1').execute

      process_commands
    end

    def handle_down_command(_options = {})
      Byebug::DownCommand.new(self, 'down 1').execute

      process_commands
    end

    def handle_frame_command(options)
      Byebug::FrameCommand.new(self, "frame #{options[:frame]}").execute

      process_commands
    end

    def handle_continue_command(_options = {})
      # Do nothing
    end

    def handle_key_binding_command(options)
      case options[:action]
      when :control_flow_next
        handle_next_command
      end
    end

    def push_navigation_bindings(key_bindings)
    end
  end
end
