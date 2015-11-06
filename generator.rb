#!/usr/bin/env ruby

require 'active_support/all'

deployment_id = 0
capsule_id    = 0
deployment_types = ["mongodb", "postgresql", "etcd", "redis", "rethinkdb", "elasticsearch", "influxdb", "rabbitmq"]

def curl(method, data)
  puts("curl http://$HOST/billing/billable -X DELETE -H "'Content-type: application/json'" -d '#{data}'")
end

# generate accounts
(1..15).to_a.each do |account_id|
  # generate deployment count
  1.upto((rand() * 10)) do |deployment|
    deployment_id  += 1
    capsule_id     += 1

    capsule_ids = [capsule_id += 1, capsule_id += 1, capsule_id += 1]

    last_date = 90.days.ago

    deployment_type = deployment_types.shuffle[0]

    start_at = (180.days * rand()).floor.seconds.ago.utc
    end_at   = rand() > 0.45 ? nil : (180.days * rand()).floor.seconds.ago.utc

    scale_range = [(rand() * 500).floor, (rand() * 500).floor].sort
    scale_count = Math.log(rand()).round.abs

    curl("POST", {
      account_id: account_id,
      sku: "capsule:hqproxy",
      identifier:"capsule:#{capsule_ids[0]}",
      group_sku: "deployment:#{deployment_type}",
      group_identifier: "deployment:#{deployment_id}",
      start_at: start_at,
      units: 1
    }.to_json)

    capsule_ids[1..-1].each do |capsule_id|
      curl("POST", {
        account_id: account_id,
        sku: "capsule:#{deployment_type}",
        identifier:"capsule:#{capsule_id}",
        group_sku: "deployment:#{deployment_type}",
        group_identifier: "deployment:#{deployment_id}",
        start_at: start_at,
        units: 1
      }.to_json)
    end

    current_time = start_at
    last_date = end_at || Time.now
    1.upto(scale_count) do
      units = ((scale_range[1] - scale_range[0]) * rand()).floor + scale_range[0]
      current_time = (last_date - ((last_date - current_time)  * rand()).floor.seconds).utc

      capsule_ids[1..-1].each do |capsule_id|
        curl("POST", {
          account_id: account_id,
          sku: "capsule:#{deployment_type}",
          identifier:"capsule:#{capsule_id}",
          group_sku: "deployment:#{deployment_type}",
          group_identifier: "deployment:#{deployment_id}",
          start_at: current_time + Math.log(rand()).days,
          units: units
        }.to_json)
      end
    end

    if end_at
      curl("DELETE", {
        account_id: account_id,
        sku: "capsule:haproxy",
        identifier:"capsule:#{capsule_ids[0]}",
        group_sku: "deployment:#{deployment_type}",
        group_identifier: "deployment:#{deployment_id}",
        end_at: end_at
      }.to_json)

      capsule_ids[1..-1].each do |capsule_id|
        curl("DELETE", {
          account_id: account_id,
          sku: "capsule:#{deployment_type}",
          identifier:"capsule:#{capsule_id}",
          group_sku: "deployment:#{deployment_type}",
          group_identifier: "deployment:#{deployment_id}",
          end_at: end_at
        }.to_json)
      end
    end
  end
end
