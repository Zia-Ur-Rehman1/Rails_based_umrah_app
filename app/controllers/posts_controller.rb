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
      flash[:notice] = "Post was successfully created."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("posts", partial: "posts/post", locals: { post: @post }),
            turbo_stream.replace("post_form", partial: "posts/form", locals: { post: Post.new }),
            turbo_stream.replace("flash", partial: "shared/flash")
          ]
        end
        format.html { redirect_to @post, notice: flash[:notice] }
      end
    else
      flash[:alert] = @post.errors.full_messages.to_sentence
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("post_form", partial: "posts/form", locals: { post: @post }),
            turbo_stream.replace("flash", partial: "shared/flash")
          ]
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post was successfully updated."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("post_#{@post.id}", partial: "posts/post", locals: { post: @post }),
            turbo_stream.replace("flash", partial: "shared/flash")
          ]
        end
        format.html { redirect_to @post, notice: flash[:notice] }
      end
    else
      flash[:alert] = @post.errors.full_messages.to_sentence
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("post_form", partial: "posts/form", locals: { post: @post }),
            turbo_stream.replace("flash", partial: "shared/flash")
          ]
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy!
    flash[:notice] = "Post was successfully destroyed."
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove("post_#{@post.id}"),
          turbo_stream.replace("flash", partial: "shared/flash")
        ]
      end
      format.html { redirect_to posts_path, notice: flash[:notice] }
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
