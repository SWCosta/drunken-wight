class Result
  attr_reader :home, :guest

  def initialize(home,guest)
    @home, @guest = home, guest
  end

  def == (other_score)
    (home == other_score.home && guest == other_score.guest) || (home == other_score.guest && guest == other_score.home)
  end

  def toto
    home <=> guest
  end

end
