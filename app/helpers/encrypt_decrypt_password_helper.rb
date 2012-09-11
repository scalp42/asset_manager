module EncryptDecryptPasswordHelper

  def encryptPassword(password)

    fieldType = FieldType.first(:type_name => "Password Field")
    blowfish = Crypt::Gost.new(fieldType.hashing_key)

   return blowfish.encrypt_string(password).to_hex_string.split(" ").join

  end

  def decryptPassword(encryptedPassword)

    fieldType = FieldType.first(:type_name => "Password Field")
    blowfish = Crypt::Gost.new(fieldType.hashing_key)

    return  blowfish.decrypt_string(encryptedPassword.to_byte_string)
  end

end
