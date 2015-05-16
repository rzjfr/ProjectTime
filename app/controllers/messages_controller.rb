class MessagesController < ApplicationController
  before_action :authenticate_user!
  def inbox
  end

  def sent
  end
end
