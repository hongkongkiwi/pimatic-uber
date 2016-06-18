module.exports = {
  title: "pimatic-uber device config schemas"
  UberPriceEstimateDevice: {
    title: "UberPriceEstimateDevice config options"
    type: "object"
    required: ["start_latitude","start_longitude","end_latitude","end_longitude"]
    properties:
      updateInterval:
        description: "seconds delay between polls of uber server"
        type: "number"
        default: 60
      sandbox:
        description: "Whether to use sandbox or live mode"
        type: "boolean"
        default: true
      start_latitude:
        description: "Latitude where your Pimatic Server is located"
        type: "number"
      start_longitude:
        description: "Longitude where your Pimatic Server is located"
        type: "number"
      end_latitude:
        description: "Latitude where your planned destination is"
        type: "number"
      end_longitude:
        description: "Longitude where your planned destination is"
        type: "number"
      showSurge:
        description: "Whether to show Surge multiplier"
        type: "boolean"
        default: true
      showETA:
        description: "Whether to show Estimated Time of Arrival"
        type: "boolean"
        default: true
      showPrice:
        description: "Whether to show estimated Price"
        type: "boolean"
        default: true
  },
  UberClosestEstimateDevice:
    title: "UberClosestEstimateDevice config options"
    type: "object"
    required: ["clientId","clientSecret","serverToken","latitude","longitude"]
    properties:
      updateInterval:
        description: "seconds delay between polls of uber server"
        type: "number"
        default: 300
      clientId:
        description: "Uber Developer OAuth Client ID"
        type: "string"
      clientSecret:
        description: "Uber Developer OAuth Client Secret"
        type: "string"
      serverToken:
        description: "Uber Developer Server Token"
        type: "string"
      language:
        description: "What language to return the results in"
        type: "string"
        default: "en_US"
      sandbox:
        description: "Whether to use sandbox or live mode"
        type: "boolean"
        default: true
      latitude:
        description: "Latitude where your Pimatic Server is located"
        type: "number"
      longitude:
        description: "Longitude where your Pimatic Server is located"
        type: "number"
}
