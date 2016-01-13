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
end
