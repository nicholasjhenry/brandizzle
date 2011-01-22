class ApplicationController < ActionController::Base
  STUFF = 'test'
  protect_from_forgery
  def my_stuff(cool_stuff)
    if @stuff == STUFF
      stuff(cool_stuff)
    end
  end

  def open
    @stuff = "hello"
    cool_stuff = "testing"
    my_stuff(cool_stuff)
  end
end
