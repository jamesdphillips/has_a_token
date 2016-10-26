module HasAToken

  # Configurable generator for build unique tokens
  class Generator
    include Contracts::Core
    include Contracts::Builtin

    UNAMBIGUOUS_CHARSET = %w( 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z ).freeze

    # @option [Symbol] :charset charset to token
    #    :unambiguous token will only contain unambiguous letters and numbers
    #    :urlsafe_base64 will return base64 token with '/' & '+' replaced w/ '-' & '_'
    #    :alphabetical will contain only A-Z characters
    # @option [Fixnum] :length of the resulting token; defaults to 24 (or 8 for unambiguous sets)
    def initialize(charset: :urlsafe_base64, length: nil)
      @length = length || (charset == :unambiguous ? 5 : 24)
      @charset = charset
    end

    # Generate a unique token
    #
    # @return [String] unique token
    Contract None => String
    def generate
      case @charset
      when :unambiguous
        generate_charset_token(UNAMBIGUOUS_CHARSET)
      when :alphabetical
        generate_charset_token(("A".."Z").to_a)
      else
        generate_secure_token
      end
    end

    private

    Contract Array => String
    def generate_charset_token(charset)
      # Fetch a random set of bytes
      randset = SecureRandom.random_number(charset.size**@length)

      # Assign to ambiguous charset
      @length
        .times
        .map do |i|
          charset.to_a[
            (randset / charset.size**i) % charset.size
          ]
        end.join
    end

    Contract None => String
    def generate_secure_token
      case @charset
      when :hex
        SecureRandom.send(@charset, Integer(@length * Rational(1, 2)))
      when :urlsafe_base64, :base64
        SecureRandom.send(@charset, Integer(@length / Rational(4, 3)))
      else
        fail ArgumentError, "Unsupported charset #{@charset}"
      end
    end
  end
end
