require 'spec_helper'

describe SocialProfile::People::Facebook do
  it "should be a Module" do
    SocialProfile::People.should be_a(Module)
  end

  context "facebook" do
    before :all do 
      # stub = stub_request(:get, FbGraph::Query.new(query).endpoint).with(
      #   :query => {:q => query, :access_token => "abc"}, 
      #   :headers => {"Host" => 'graph.facebook.com'}
      # ).to_return(
      #   :body => '{"data": [{"friend_count": 230}]}'
      # )

      FbGraph.debug!
    end

    before(:each) do
      @user = SocialProfile::Person.get(:facebook, "100000730417342", "abc")
    end

    it "should be a facebook profile" do
      @user.should be_a(SocialProfile::People::Facebook)
    end

    it "should response to friends_count" do
      mock_fql SocialProfile::People::Facebook::FRIENDS_FQL, SocialProfile.root_path.join('spec/mock_json/facebook/friends_count.json'), :access_token => "abc" do
        @user.friends_count.should > 0
      end
    end

    it "should response to first_post_exists?" do
      _sql = SocialProfile::People::Facebook::FIRST_POST_SQL.gsub('{date}', '1293832800')

      mock_fql _sql, SocialProfile.root_path.join('spec/mock_json/facebook/first_post.json'), :access_token => "abc" do
        @user.first_post_exists?(2011).should > 0
      end
    end
  end
end
