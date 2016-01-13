class User < ActiveRecord::Base
      before_save { self.email = email.downcase } # Obvious behavior.
    # Curly braces are optional when passing hashes as the final argument
    # in a method.
    # Parentheses on function calls are optional.
      validates :name, presence: true, length: { maximum: 50 } 
      # the validates method is equivalent to
      # validates (:name, presence: true).
      validates :email, presence: true, length: { maximum: 255 }, 
      uniqueness: { case_sensitive: false } # avoiding problems like Br@ExcAmple.com
      has_secure_password # adds the ability to save a securily hashed password_digest
      # attribute to the database. Additionally adds an authenticate method that returns the user
      # when the password is correct.
      
end
