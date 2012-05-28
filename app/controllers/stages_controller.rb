class StagesController < CupController
  def index
    render text: "it works"
  end

  def show
    render text: params.to_yaml
  end
end
