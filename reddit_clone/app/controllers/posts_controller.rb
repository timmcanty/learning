class PostsController < ApplicationController

  def show
    @post = Post.find(params[:id])
    render :show
  end

  def new
    @post = Post.new
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id

    if @post.save
      params[:subs].values.each do |id|
        PostSub.create!(post_id: @post.id, sub_id: id)
      end
      redirect_to subs_url
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      wanted_sub_ids = params[:subs].values.map(&:to_i) if params[:subs]
      wanted_sub_ids ||= []

      PostSub.destroy(@post.post_sub_ids)
      (wanted_sub_ids).each do |sub_id|
        PostSub.create( post_id: @post.id, sub_id: sub_id)
      end
      redirect_to subs_url
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content)
  end
end
