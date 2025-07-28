class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @posts = Post.all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("posts", partial: "posts/post", locals: { post: @post }),
            turbo_stream.replace("post_form", partial: "posts/form", locals: { post: Post.new })
          ]
        end
        format.html { redirect_to @post, notice: "Post was successfully created." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("post_form", partial: "posts/form", locals: { post: @post })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @post.update(post_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("post_#{@post.id}", partial: "posts/post", locals: { post: @post })
        end
        format.html { redirect_to @post, notice: "Post was successfully updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("post_form", partial: "posts/form", locals: { post: @post })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("post_#{@post.id}") }
      format.html { redirect_to posts_path, notice: "Post was successfully destroyed." }
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title)
    end
end
