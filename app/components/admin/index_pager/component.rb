module Admin
  module IndexPager
    class Component < ViewComponent::Base
      include Pagy::Frontend # Include Pagy helpers directly in the component

      def initialize(pagy:, instance:, player_type: nil)
        @pagy = pagy
        @instance = instance
        @player_type = player_type
      end

      def page_path(page)
        # Preserve the player_type parameter when paginating
        url_params = request.query_parameters.dup
        url_params[:page] = page
        url_params[:player_type] = @player_type if @player_type.present?

        url_for(url_params)
      end
    end
  end
end
