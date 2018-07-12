class RSAHandler
  def self.encrypt message
    # 2 random prime numbers
    prime1  = 3
    prime2  = 7
    product = prime1 * prime2
    totient = (prime1 - 1) * (prime2 - 1)

    public_key = 2

    # for checking co-prime which satisfies public_key>1
    while public_key < totient do
      count = public_key.gcd(totient)

      break if count == 1
      public_key += 1
    end

    # can be any arbitrary value
    arbitrary = 2

    #choosing private_key such that it satisfies private_key * public_key = 1 + arbitrary * totient
    private_key = (1 + (arbitrary * totient)) / public_key

    encrypted_message = ''

    message.chars.each do |char|
      x1 = char.to_i ** public_key
      x1 = x1 % product

      encrypted_message << x1.to_s
    end

    encrypted_message
  end
end
