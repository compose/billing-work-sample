# Business Systems Developer Work Sample

Thank you for taking time to consider working at Compose.  This is a work sample to help us kick off the relationship.  We find starting with this process removes the uneasy feelings that resumés give us.

This should take around 5 - 6 hours.  Don't sweat if this takes longer.  While we provide a time, we respect quality work far more than an immediate response.  Thus, we put this timeframe on the project to be upfront with you.  But, the time should not restrict you.

## The work samples

Distributed billing systems are an interesting beast. We are looking for someone who can work through the logical process of simplifying complexity into a system that other people will find easy to use.  The following tasks are part of the work samples:

1. System design
2. API programming
3. Reports

The following tasks will be based on the assets in the following files:

* `api-calls.sh`, which can be run with `sh api-calls.sh $HOSTNAME` where `$HOSTNAME` is equal to an API you will create in step #2
* `generator.rb` is a file we used the generate the `api-calls.sh`.  It can be used to generate a new set of API commands to test an API edge cases, but it is not required.

## 1. System design

Investigate the calls we are making in `api-calls.sh`.  Describe priorities and assumptions you will make for a system that would solve for these inputs (you will also want to read #3 to get a list of other requirements).

## 2. API programming

Build a system which takes accepts the calls `api-calls.sh`.

## 3. Reports

Build a UI that shows the following:

* overall view of revenue for a month
* breakdown of revenue per customer for a month
* breakdown of revenue per product for a month

## Words of encouragement

The `api-calls.sh` is purposefully
