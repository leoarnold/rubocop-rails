# frozen_string_literal: true

module RuboCop
  module Rails
    # Contains node matchers for common Rails DSL.
    module Language
      extend RuboCop::NodePattern::Macros

      # @!method rails?(node)
      def_node_matcher :rails?, <<~PATTERN
        (const {nil? cbase} :Rails)
      PATTERN

      # @!method rails_env?(node)
      def_node_matcher :rails_env?, <<~PATTERN
        (send #rails? :env)
      PATTERN

      # @!method rails_root?(node)
      def_node_matcher :rails_root?, <<~PATTERN
        (send #rails? {:root :public_path})
      PATTERN
    end
  end
end
