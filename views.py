from rest_framework.decorators import api_view, permission_classes, parser_classes
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from rest_framework.permissions import IsAdminUser
from rest_framework.response import Response
from rest_framework import status

from .models import Listing, ListingImage
from .serializers import ListingSerializer


@api_view(['GET'])
def listings_root(request):
    # GET: list listings (optional ?status=approved)
    status_q = request.query_params.get('status')
    if status_q:
        listings = Listing.objects.filter(status=status_q).order_by('-created_at')
    else:
        listings = Listing.objects.all().order_by('-created_at')
    serializer = ListingSerializer(listings, many=True, context={'request': request})
    return Response(serializer.data)


@api_view(['POST'])
@parser_classes([JSONParser, MultiPartParser, FormParser])
def create_listing(request):
    """
    Create a new listing. Accepts JSON or multipart form data with optional images.
    """
    data = request.data.copy()
    listed_by = request.user.username if request.user.is_authenticated else data.get('listed_by', 'anonymous')
    data['listed_by'] = listed_by

    serializer = ListingSerializer(data=data)
    if serializer.is_valid():
        listing = serializer.save(status='pending')

        # handle uploaded images if any
        images = request.FILES.getlist('images')
        for img in images:
            ListingImage.objects.create(listing=listing, image=img)

        resp = ListingSerializer(listing, context={'request': request})
        return Response(resp.data, status=status.HTTP_201_CREATED)

    print(f'Serializer errors: {serializer.errors}')
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def approved_listings(request):
    listings = Listing.objects.filter(status='approved').order_by('-created_at')
    serializer = ListingSerializer(listings, many=True, context={'request': request})
    return Response(serializer.data)


@api_view(['GET'])
def my_listings(request):
    username = request.user.username if request.user.is_authenticated else request.query_params.get('listed_by')
    if not username:
        return Response({'detail': 'Authentication required or provide listed_by parameter.'}, status=status.HTTP_403_FORBIDDEN)
    listings = Listing.objects.filter(listed_by=username).order_by('-created_at')
    serializer = ListingSerializer(listings, many=True, context={'request': request})
    return Response(serializer.data)


@api_view(['GET'])
#@permission_classes([IsAdminUser])
def pending_listings(request):
    listings = Listing.objects.filter(status='pending').order_by('-created_at')
    serializer = ListingSerializer(listings, many=True, context={'request': request})
    return Response(serializer.data)


@api_view(['PATCH'])
#@permission_classes([IsAdminUser])
def approve_listing(request, pk):
    try:
        listing = Listing.objects.get(pk=pk)
    except Listing.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    listing.status = 'approved'
    listing.save()
    return Response({'status': listing.status})


@api_view(['PATCH'])
#@permission_classes([IsAdminUser])
def reject_listing(request, pk):
    try:
        listing = Listing.objects.get(pk=pk)
    except Listing.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    listing.status = 'rejected'
    listing.save()
    return Response({'status': listing.status})


@api_view(['GET'])
#@permission_classes([IsAdminUser])
def admin_stats(request):
    total = Listing.objects.count()
    pending = Listing.objects.filter(status='pending').count()
    approved = Listing.objects.filter(status='approved').count()
    rejected = Listing.objects.filter(status='rejected').count()

    # simple 7-day trend
    from django.utils import timezone
    from datetime import timedelta

    trend = []
    today = timezone.now().date()
    for i in range(6, -1, -1):
        day = today - timedelta(days=i)
        count = Listing.objects.filter(created_at__date=day).count()
        trend.append({'date': str(day), 'count': count})

    return Response({
        'total': total,
        'pending': pending,
        'approved': approved,
        'rejected': rejected,
        'trend': trend,
    })

