require "test_helper"

class PostsTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get new" do
    get new_post_url
    assert_response :success
  end

  test "should create post with turbo stream" do
    assert_difference("Post.count") do
      post posts_url,
           params: { post: {
             title: @post.title
           } },
           as: :turbo_stream
    end

    assert_response :success
    assert_turbo_stream action: "append", target: "posts"
    assert_turbo_stream action: "replace", target: "post_form"
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post with turbo stream" do
    patch post_url(@post),
          params: { post: {
            title: @post.title
          } },
          as: :turbo_stream

    assert_response :success
    assert_turbo_stream action: "replace", target: dom_id(@post)
  end

  test "should destroy post with turbo stream" do
    assert_difference("Post.count", -1) do
      delete post_url(@post), as: :turbo_stream
    end

    assert_response :success
    assert_turbo_stream action: "remove", target: dom_id(@post)
  end
end
