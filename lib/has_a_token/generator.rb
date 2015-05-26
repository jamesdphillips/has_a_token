module HasAToken

  # Configurable generator for build unique tokens
  class Generator
    include Contracts

    UNAMBIGUOUS_CHARSET = %w( 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z ).freeze

    # @option [Symbol] :charset charset to token
    #    :unambiguous token will only contain unambiguous letters and numbers
    #    :urlsafe_base64 will return base64 token with '/' & '+' replaced w/ '-' & '_'
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
        generate_unambiguous_token
      else
        generate_secure_token
      end
    end

    private

    Contract None => String
    def generate_unambiguous_token
      # Fetch a random set of bytes
      randset = SecureRandom.random_number(UNAMBIGUOUS_CHARSET.size**@length)

      # Assign to ambiguous charset
      @length
        .times
        .map do |i|
          UNAMBIGUOUS_CHARSET.to_a[
            (randset / UNAMBIGUOUS_CHARSET.size**i) % UNAMBIGUOUS_CHARSET.size
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
