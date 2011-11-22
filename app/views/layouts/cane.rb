def shuffle_string (str)
  str.split('').shuffle.join('')
end

class String
  def shuffle
    self.split('').shuffle.join('')
  end
end

person1 = {:first => "Mario", :last => "Piras"}
person2 = {:first => "Alessandro", :last => "Piras"}
person3 = {:first => "Anna", :last => "Zedda"}

params = {:father => person1, :mather => person3, :child => person2}

puts params[:father][:first]
