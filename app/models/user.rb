class User < ActiveRecord::Base
	has_secure_password 
	# authenticate is also used in the above method, due to metaprogramming 
end