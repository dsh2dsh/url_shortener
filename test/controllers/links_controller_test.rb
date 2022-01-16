require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @link = links(:one)
    cookies[:uuid] = @link.uuid
  end

  test 'should get index' do
    get links_url
    assert_response :success
  end

  test 'get index returns array of links as json' do
    get links_url, as: :json
    assert_response :success
    assert_not response.parsed_body.empty?
  end

  test 'get index generates new uuid cookie' do
    cookies.delete 'uuid'
    get links_url, as: :json
    assert_response :success
    assert_not_equal cookies[:uuid], @link.uuid
    assert_empty response.parsed_body
  end

  test 'should get new' do
    get new_link_url
    assert_response :success
    assert_equal cookies[:uuid], @link.uuid
  end

  test 'should get new without uuid' do
    cookies.delete 'uuid'
    get new_link_url
    assert_response :success
    assert_not_nil cookies[:uuid]
  end

  test 'should create link' do
    assert_difference -> { Link.where(uuid: @link.uuid).count } do
      post links_url,
           params: {
             link: {
               expire_at: @link.expire_at,
               url: @link.url
             }
           }
    end

    assert_redirected_to link_url(Link.last)
  end

  test 'create link should expire too old links' do
    expired = links(:expired)
    expired.update expire_at: (Time.current - 1.day)
    assert_difference('Link.count', 0) do
      post links_url,
           params: {
             link: {
               expire_at: @link.expire_at,
               url: @link.url
             }
           }
    end
  end

  test 'should show link' do
    get link_url(@link)
    assert_response :success
  end

  test 'should not show link without uuid' do
    cookies.delete 'uuid'
    assert_raises ActiveRecord::RecordNotFound do
      get link_url(@link)
    end
  end

  test 'should get edit' do
    get edit_link_url(@link)
    assert_response :success
  end

  test 'should update link' do
    patch link_url(@link),
          params: {
            link: {
              expire_at: @link.expire_at,
              slug: @link.slug,
              url: @link.url
            }
          }
    assert_redirected_to link_url(@link)
  end

  test 'should destroy link' do
    assert_difference -> { Link.where(uuid: @link.uuid).count }, -1 do
      delete link_url(@link)
    end

    assert_redirected_to links_url
  end

  test 'should redirect to url without uuid' do
    cookies.delete 'uuid'
    get short_url(slug: @link.slug)
    assert_redirected_to @link.url
    assert_nil cookies[:uuid]
  end

  test 'should not redirect to expired link' do
    expired = links(:expired)
    expired.update expire_at: (Time.current - 1.day)
    assert_raises ActiveRecord::RecordNotFound do
      get short_url(slug: expired.slug)
    end
  end

  test 'should redirect to link with future expiration' do
    expired = links(:expired)
    expired.update expire_at: (Time.current + 1.day)
    get short_url(slug: @link.slug)
    assert_redirected_to @link.url
  end
end
