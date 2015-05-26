require "active_support/all"

module HasAToken

  # Model concern
  # @example unambiguous token
  #   class Workspace < ActiveRecord::Base
  #     # ...
  #     has_a_token :invite_code, charset: :unambiguous
  #     has_a_token :password_reset_token, length: 32
  module Concern
    extend ActiveSupport::Concern

    module ClassMethods # rubocop:disable all
      # @param name [Symbol] name of the column
      # @param opts [Hash] generator options
      # @option opts [Symbol] :charset
      # @option opts [Symbol] :length
      # @example
      #   has_a_token :invite_code, charset: unambiguous # generates easily readable token
      #   has_a_token :password_reset, length: 32  # generates a secure token of 32 length
      #
      #   before_create :generate_invite_code
      #   before_save :generate_password_reset_token, if: "password_reset_token.nil?"
      #
      #   user = User.first
      #   user.reset_password_reset_token!
      # @see https://github.com/jamesdphillips/has_a_token/blob/master/lib/has_a_token/generator.rb
      def has_a_token(name = :token, opts = {}) # rubocop:disable all
        if String(name).match(/(_token|_code)$/)
          method_name = name.to_s
        else
          method_name = "#{name}_token"
        end

        define_method "generate_#{method_name}" do
          self[method_name] = loop do
            random_token = HasAToken::Generator.new(opts).generate
            break random_token unless self.class.exists?(Hash[method_name, random_token])
          end
        end

        define_method "reset_#{method_name}!" do
          send("generate_#{method_name}")
          save!
        end
      end
    end
  end
end
