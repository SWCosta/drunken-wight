class GroupMatch < Match
  has_one :group, through: :home
end
