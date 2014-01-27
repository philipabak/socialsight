class CommentsController < ApplicationController
	respond_to :js

  def create
    @guide = Guide.find(params[:guide_id])
    @comment = Comment.build_from(@guide, current_user.id, params[:comment][:body])
    @comment.rating = params[:rating] unless params[:rating].blank?

    if @comment.save
      @guide.update_avg_rating
      respond_with(@comment)
    else
      render nothing: true, status: :internal_server_error
    end
  end

  def update
    @guide = Guide.find(params[:guide_id])
    @comment = Comment.find(params[:id])
    @comment.body = params[:comment][:body]
    @comment.rating = params[:rating]
    if @comment.save
      @guide.update_avg_rating
      respond_with(@comment)
    else
      render nothing: true, status: :internal_server_error
    end
  end

  def editcomment_template
    @guide = Guide.find(params[:guide_id])
    @comment = Comment.find(params[:comment_id])
  end
end
