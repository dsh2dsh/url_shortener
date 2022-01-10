require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  def setup
    @link = links(:one)
  end

  test 'presence of url' do
    assert @link.valid?
    @link.url = nil
    assert @link.invalid?
  end

  test 'autogeneration of slug' do
    @link.slug = nil
    assert @link.valid?
    assert_not_nil @link.slug
  end

  test 'uniqueness of slug' do
    link2 = Link.new(url: @link.url, slug: @link.slug)
    assert link2.invalid?
  end

  test 'random slugs' do
    @link.slug = nil
    @link.valid?
    slug1 = @link.slug
    @link.slug = nil
    @link.valid?
    slug2 = @link.slug
    assert_not_equal slug1, slug2
  end

  test 'url format' do
    @link.url = 'abcd'
    assert @link.invalid?
    @link.url = 'mailto://abcd'
    assert @link.invalid?
    @link.url = 'http://127.0.0.1'
    assert @link.valid?
    @link.url = 'https://127.0.0.1'
    assert @link.valid?
  end

  test 'expiration of links' do
    @link.expire_at = Time.now - 1.day
    assert @link.save
    cnt = Link.count
    Link.expire_links
    assert_equal 1, cnt - Link.count
  end

  test 'presence of uuid' do
    assert @link.valid?
    @link.uuid = nil
    assert @link.invalid?
  end
end
