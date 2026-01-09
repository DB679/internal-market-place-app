from django.db import models

class Listing(models.Model):

    LISTING_TYPE_CHOICES = [
        ('sell', 'Sell'),
        ('rent', 'Rent'),
        ('donate', 'Donate'),
        ('lend', 'Lend'),
        ('share', 'Share'),
    ]

    STATUS_CHOICES = [
        ('pending', 'Pending Approval'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
    ]

    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)

    listing_type = models.CharField(
        max_length=10,
        choices=LISTING_TYPE_CHOICES
    )

    # Price rules:
    # sell  -> required
    # rent  -> required (per day / month decided at UI)
    # donate -> NULL
    # lend  -> NULL
    # share -> NULL
    price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        null=True,
        blank=True
    )

    # For now free text; later FK to Employee
    listed_by = models.CharField(max_length=150)

    status = models.CharField(
        max_length=10,
        choices=STATUS_CHOICES,
        default='pending'
    )

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.title} ({self.listing_type}) - {self.status}"

class ListingImage(models.Model):
    listing = models.ForeignKey(
        Listing,
        related_name='images',
        on_delete=models.CASCADE
    )

    image = models.ImageField(upload_to='listing_images/')
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Image for {self.listing.title}"
