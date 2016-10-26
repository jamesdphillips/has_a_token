require_relative "./test_helper.rb"

# Test Generator class
class GeneratorTests < Minitest::Test
  def test_unambiguous_length
    assert HasAToken::Generator.new(charset: :unambiguous, length: 8).generate.length == 8
    assert HasAToken::Generator.new(charset: :unambiguous, length: 10).generate.length == 10
  end

  def test_unambiguous_charset
    SecureRandom.stub :random_number, 456_975 do # ZZZZ
      assert_instance_of String, HasAToken::Generator.new(charset: :unambiguous, length: 1).generate
      assert_equal "ZZZZ", HasAToken::Generator.new(charset: :unambiguous, length: 4).generate
    end
  end

  def test_secure_token_length
    assert HasAToken::Generator.new(charset: :urlsafe_base64, length: 8).generate.length == 8
    assert HasAToken::Generator.new(charset: :base64, length: 8).generate.length == 8
    assert HasAToken::Generator.new(charset: :hex, length: 8).generate.length == 8
  end

  def test_secure_token_charset
    assert_raises(ArgumentError) { HasAToken::Generator.new(charset: :squidward).generate }
    SecureRandom.stub :base64, "ABCD" do
      assert_equal "ABCD", HasAToken::Generator.new(charset: :base64).generate
    end
    SecureRandom.stub :hex, "1234" do
      assert_equal "1234", HasAToken::Generator.new(charset: :hex).generate
    end
  end
end
