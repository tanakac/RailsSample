# encoding: utf-8
#---
# Excerpted from "Agile Web Development with Rails, 4th Ed.",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#
# 日本語版については http://ssl.ohmsha.co.jp/cgi-bin/menu.cgi?ISBN=978-4-274-06866-9
#---
require 'test_helper'
require './config/routes.rb'

class RoutingTest < ActionController::TestCase

  def test_recognizes
    ActionController::Routing.use_controllers! ["store"]
    load "./config/routes.rb"

    # デフォルトのindexアクションが生成されることを確認する
    assert_recognizes({"controller" => "store", "action" => "index"}, "/store")
    
    # アクションへのルーティングを確認する
    assert_recognizes({"controller" => "store", "action" => "list"}, 
                      "/store/list")
    
    # パラメータのあるルーティングを確認する
    assert_recognizes({ "controller" => "store", 
                        "action" => "add_to_cart", 
                       "id" => "1" },
                      "/store/add_to_cart/1")

    # パラメータのあるルーティングを確認する
    assert_recognizes({ "controller" => "store", 
                        "action" => "add_to_cart", 
                        "id" => "1",
                        "name" => "dave" }, 
                      "/store/add_to_cart/1",
                      { "name" => "dave" } ) # URLのあとに ?name=dave を付けるのと似ている

    # POSTリクエストにする
    assert_recognizes({ "controller" => "store", 
                        "action" => "add_to_cart", 
                        "id" => "1" }, 
                      { :path => "/store/add_to_cart/1", :method => :post })
  end
  
  def test_generates
    ActionController::Routing.use_controllers! ["store"]
    load "config/routes.rb"

    assert_generates("/store", :controller => "store", :action => "index")
    assert_generates("/store/list", :controller => "store", :action => "list")
    assert_generates("/store/add_to_cart/1", 
                     { :controller => "store", :action => "add_to_cart", 
                       :id => "1", :name => "dave" },
                     {}, { :name => "dave"})
  end
  
  def test_routing
    ActionController::Routing.use_controllers! ["store"]
    load "config/routes.rb"

    assert_routing("/store", :controller => "store", :action => "index")
    assert_routing("/store/list", :controller => "store", :action => "list")
    assert_routing("/store/add_to_cart/1", 
                   :controller => "store", :action => "add_to_cart", :id => "1")
  end
  
  def test_alternate_routing
    ActionController::Routing.use_controllers! ["store"]
    load "config/routes.rb"

    assert_generates("/store", :controller => "store")
    
    with_routing do |set|
      set.draw do |map|
        map.connect "shop/:action/:id", :controller => "store"
      
      assert_generates("/shop", :controller => "store")
      assert_recognizes({:controller => "store", :action => "index"}, "/shop")
      end
    end
    
    assert_generates("/store", :controller => "store")
  end    
    
end

