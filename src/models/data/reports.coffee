_ = require 'lodash'
moment = require 'moment'

status = ['Complete', 'Open', 'New']
inspected_by = ['Ben Lynch', 'John Wang', 'Pushkar Gupte', 'John Smith', 'Tim Thomas']
location = ['Auckland', 'Wellington', 'Christchurch', 'Dunedin', 'Queenstown', 'Sydney', 'Melbourne']
vehicle_number = [8393, 103843, 1937, 99301, 777838, 381030, 9304, 9301, 883, 19]
vehicle_plate = ['XK1466', 'DLK451', 'HJD892', 'LL9198', 'SUV828', 'XV9392']
outcome = ['Passed', 'Failed', 'Attention']
inspection_type = ['Pre trip', 'Post trip']

API = ->

API.get = (page, rows, callback) ->
    data = []
    x = 0

    while x < rows
        data.push(
            id: page + ' - ' + x
            status: _.sample(status)
            inspected_by: _.sample(inspected_by)
            inspection_type: _.sample(inspection_type)
            created_at: moment().subtract(_.random(1, 365), 'days').subtract(_.random(1, 60), 'minutes').toISOString()
            location: _.sample(location)
            vehicle:
                number: _.sample(vehicle_number)
                plate: _.sample(vehicle_plate)
            outcome: _.sample(outcome)
            open_actions: _.random(0, 6)
        )

        x++

    _.delay () ->
        callback(null, data)
    , 300

module.exports = API
