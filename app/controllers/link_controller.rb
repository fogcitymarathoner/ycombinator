class LinkController < ApplicationController
  def new  
        @link = Link.new
  end
  
    def list
      @link = Link.find(:all)
   end
    def show
      @link = Link.find(params[:id])
   end
      def create
      @link = Link.new(params[:link])
    end
end