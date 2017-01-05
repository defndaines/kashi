# Open RTB Transport Guidelines

## Transport

Use HTTP POST for auction communications. (GET is OK for notifications.)

## JSON

The bid request specifies the representation as a mime type using the
Content-Type HTTP header. The mime type for the standard JSON representation is
“application/json”. The format of the bid response must be the same as
the bid request.

If the content-type is missing, the bidder should assume the type is
application/json, unless a different default has been selected by an exchange.

## Data Encoding

The encoding value used should be “gzip”.
```
Accept-Encoding: gzip

Content-Encoding: gzip
```
     
## OpenRTB Version HTTP Header

The OpenRTB Version should be passed in the header of a bid request with a
custom header parameter.
```
x-openrtb-version: 2.5
```

## Privacy by Design

The OpenRTB project fully supports privacy policies as specified by buyers and
sellers of advertising. In particular OpenRTB supports do-not-track (Section
3.2.18), COPPA restriction signaling (Section 7.5), and the ability to pass user
preferences from sellers to buyers through the User object (Section 3.2.20).
