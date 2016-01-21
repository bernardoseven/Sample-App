class User < ActiveRecord::Base
      # we create an accessible attribute.
      attr_accessor :remember_token, :activation_token
      before_save :downcase_email # Obvious behavior.
      before_create :create_activation_digest
      
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
      validates :password, presence: true, length: { minimum: 6 } # validates password
      # presence and length.
      # Returns the hash digest of the given string.
      def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
      end
      # Returns a random token. If we use the console, and puts literally 
      # SecureRandom.urlsafe_base64, the console returns a random string that's almost
      # imposible to be repeated with some other user's token.
      def User.new_token
        SecureRandom.urlsafe_base64
      end
      # remembers a user in the database for use in persistent sessions.
      def remember
        self.remember_token = User.new_token # gives the unique hashed string to
        # the current user.
        update_attribute(:remember_digest, User.digest(remember_token)) # updates
        # the remember digest.
      end
      # returns true if the given token matches the digest.
      def authenticate?(remember_token)
        return false if remember_digest.nil? # fix the problem with permanent sessions
        # in different browsers.
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
      end
      # Returns true if the given token matches the digest.
      def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
      end
      # forgets a user. As always, the helper does the heavy work.
      def forget
        update_attribute(:remember_digest, nil)
      end
      
      private
      # converts email to all lower case.
      def downcase_email
        self.email = email.downcase
      end
      # creates and assigns the activation token and digest.
      def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
      end
end
