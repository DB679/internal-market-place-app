# listings/serializers.py
from rest_framework import serializers
from .models import Listing, ListingImage


class ListingImageSerializer(serializers.ModelSerializer):
    # Return full URL to the image
    image = serializers.SerializerMethodField()
    
    def get_image(self, obj):
        request = self.context.get('request')
        if obj.image:
            if request:
                return request.build_absolute_uri(obj.image.url)
            return obj.image.url
        return None
    
    class Meta:
        model = ListingImage
        fields = ('id', 'image', 'uploaded_at')


class ListingSerializer(serializers.ModelSerializer):
    images = ListingImageSerializer(many=True, read_only=True)

    class Meta:
        model = Listing
        fields = ('id', 'title', 'description', 'listing_type', 'price', 'listed_by', 'status', 'created_at', 'updated_at', 'images')
        read_only_fields = ('id', 'status', 'created_at', 'updated_at', 'images')
