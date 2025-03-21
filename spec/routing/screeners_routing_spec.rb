require "rails_helper"

RSpec.describe ScreenersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/screeners").to route_to("screeners#index")
    end

    it "routes to #new" do
      expect(get: "/screeners/new").to route_to("screeners#new")
    end

    it "routes to #show" do
      expect(get: "/screeners/1").to route_to("screeners#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/screeners/1/edit").to route_to("screeners#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/screeners").to route_to("screeners#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/screeners/1").to route_to("screeners#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/screeners/1").to route_to("screeners#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/screeners/1").to route_to("screeners#destroy", id: "1")
    end
  end
end
