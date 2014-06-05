require 'test_helper'

class BulletsControllerTest < ActionController::TestCase
  setup do
    @bullet = bullets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bullets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bullet" do
    assert_difference('Bullet.count') do
      post :create, bullet: { big_story_id: @bullet.big_story_id, content: @bullet.content, rank: @bullet.rank }
    end

    assert_redirected_to bullet_path(assigns(:bullet))
  end

  test "should show bullet" do
    get :show, id: @bullet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bullet
    assert_response :success
  end

  test "should update bullet" do
    put :update, id: @bullet, bullet: { big_story_id: @bullet.big_story_id, content: @bullet.content, rank: @bullet.rank }
    assert_redirected_to bullet_path(assigns(:bullet))
  end

  test "should destroy bullet" do
    assert_difference('Bullet.count', -1) do
      delete :destroy, id: @bullet
    end

    assert_redirected_to bullets_path
  end
end
