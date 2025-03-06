## Screening Request

* User can start, stop, and return to new request
* User can duplicate a previous request
* User can cancel a request
* User can archive a request
* User can share a request
* User can print a request with invoice
* User can export a list of requests (maybe)
* User cannot edit request after staff finalizes
* Users can add comments to requests

### Attributes

* title_id
* user_id
* asignee_id
* organization_id
* venue_id
* deliverable_id
* deliverable_type
* shipping_type
* shipping_code
* request_host
* request_status
* payment_status
* fulfillment_status
* staff_price
* staff_price_notes
* screening_date_and_time
* screening_date_notes
* is_ticketed?
* ticket_price
* expected_attendance
* marketing_strategy
* file_format
* equipment_need_notes
* user_notes
* mailing_list_opt_in
* agree_to_terms

### Request Statuses

#### request_status

* requested
* offer_sent
* offer_rejected
* offer_approved
* canceled_by_user
* canceled_by_staff
* completed

#### payment_status

* pending
* invoice_sent
* payment_received
* payment_refunded

#### fulfillment_status

* pending
* shipped
* completed

## Title

* name

## User

* phone_number
* email_address
* name

## UserOrganization

* user_id
* organization_id
* default

## Organization

* name
* address
* business_type
* organization_type
* user_notes
* website_url
* linkedin_handle
* tiktok_handle
* facebook_handle
* reelgood_handle
* instagram_handle
* x_handle
* bluesky_handle

## UserVenue

* user_id
* venue_id
* default

## Venue

* name
* address
* website_url
* email_address
* phone_number
* capacity
* number_of_screens
* user_notes
